
import 'package:sqflite/sqflite.dart';

import '../core/database/app_database.dart';
import '../models/pagamento.dart';

class PagamentoRepository {
  final AppDatabase _database = AppDatabase.instance;

  static const _statusPermitidos = {
    'pendente',
    'pago',
    'cancelado',
  };

  void _validar(Pagamento pagamento) {
    if (!pagamento.valor.isFinite || pagamento.valor < 0) {
      throw ArgumentError('Informe um valor válido.');
    }

    if (!_statusPermitidos.contains(pagamento.status)) {
      throw ArgumentError('Status de pagamento inválido.');
    }

    if (pagamento.status == 'pago' &&
        pagamento.dataPagamento == null) {
      throw ArgumentError(
        'Informe a data do pagamento recebido.',
      );
    }
  }

  // CREATE
  Future<int> inserir(Pagamento pagamento) async {
    _validar(pagamento);

    final db = await _database.database;

    return db.transaction((txn) async {
      final atendimento = await txn.query(
        'atendimentos',
        columns: ['id'],
        where: 'id = ?',
        whereArgs: [pagamento.atendimentoId],
        limit: 1,
      );

      if (atendimento.isEmpty) {
        throw StateError('Atendimento não encontrado.');
      }

      return txn.insert(
        'pagamentos',
        pagamento.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    });
  }

  // READ - Listar pagamentos
  Future<List<Pagamento>> listar() async {
    final db = await _database.database;

    final resultado = await db.query(
      'pagamentos',
      orderBy: 'id DESC',
    );

    return resultado
        .map((map) => Pagamento.fromMap(map))
        .toList();
  }

  // READ - Buscar pagamento pelo ID
  Future<Pagamento?> buscarPorId(int id) async {
    final db = await _database.database;

    final resultado = await db.query(
      'pagamentos',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (resultado.isEmpty) return null;

    return Pagamento.fromMap(resultado.first);
  }

  // READ - Pagamentos de um atendimento
  Future<List<Pagamento>> listarPorAtendimento(
    int atendimentoId,
  ) async {
    final db = await _database.database;

    final resultado = await db.query(
      'pagamentos',
      where: 'atendimento_id = ?',
      whereArgs: [atendimentoId],
      orderBy: 'id DESC',
    );

    return resultado
        .map((map) => Pagamento.fromMap(map))
        .toList();
  }

  // UPDATE
  Future<int> atualizar(Pagamento pagamento) async {
    if (pagamento.id == null) {
      throw ArgumentError('Pagamento sem ID.');
    }

    _validar(pagamento);

    final db = await _database.database;

    return db.update(
      'pagamentos',
      pagamento.toMap(),
      where: 'id = ?',
      whereArgs: [pagamento.id],
    );
  }

  // UPDATE - Marcar como pago
  Future<int> marcarComoPago(
    int id, {
    String? formaPagamento,
  }) async {
    final db = await _database.database;

    return db.update(
      'pagamentos',
      {
        'status': 'pago',
        'data_pagamento': DateTime.now().toIso8601String(),
        'forma_pagamento': formaPagamento,
      },
      where: 'id = ? AND status = ?',
      whereArgs: [id, 'pendente'],
    );
  }

  // DELETE
  Future<int> excluir(int id) async {
    final db = await _database.database;

    return db.delete(
      'pagamentos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // RESUMO FINANCEIRO
  Future<Map<String, dynamic>> obterResumo() async {
    final db = await _database.database;

    final resultado = await db.rawQuery('''
      SELECT
        COUNT(*) AS quantidade,
        COALESCE(
          SUM(CASE WHEN status = 'pago'
            THEN valor ELSE 0 END), 0
        ) AS total_recebido,
        COALESCE(
          SUM(CASE WHEN status = 'pendente'
            THEN valor ELSE 0 END), 0
        ) AS total_pendente
      FROM pagamentos
    ''');

    final resumo = resultado.first;

    return {
      'quantidade': resumo['quantidade'] as int,
      'total_recebido':
          (resumo['total_recebido'] as num).toDouble(),
      'total_pendente':
          (resumo['total_pendente'] as num).toDouble(),
    };
  }
}
