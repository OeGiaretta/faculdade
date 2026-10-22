
import 'package:sqflite/sqflite.dart';

import '../core/database/app_database.dart';
import '../models/atendimento.dart';

class AtendimentoRepository {
  final AppDatabase _database = AppDatabase.instance;

  // CREATE
  // Registra o atendimento e conclui o agendamento
  // dentro da mesma transação SQLite.
  Future<int> inserir(Atendimento atendimento) async {
    final db = await _database.database;

    return db.transaction((txn) async {
      final agendamentos = await txn.query(
        'agendamentos',
        where: 'id = ?',
        whereArgs: [atendimento.agendamentoId],
        limit: 1,
      );

      if (agendamentos.isEmpty) {
        throw StateError('Agendamento não encontrado.');
      }

      final status = agendamentos.first['status'] as String;

      if (status == 'cancelado' ||
          status == 'nao_compareceu') {
        throw StateError(
          'Não é possível registrar atendimento '
          'para uma consulta cancelada ou não realizada.',
        );
      }

      final existentes = await txn.query(
        'atendimentos',
        columns: ['id'],
        where: 'agendamento_id = ?',
        whereArgs: [atendimento.agendamentoId],
        limit: 1,
      );

      if (existentes.isNotEmpty) {
        throw StateError(
          'Este agendamento já possui um atendimento.',
        );
      }

      final id = await txn.insert(
        'atendimentos',
        atendimento.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      await txn.update(
        'agendamentos',
        {'status': 'concluido'},
        where: 'id = ?',
        whereArgs: [atendimento.agendamentoId],
      );

      return id;
    });
  }

  // READ - Lista todos os atendimentos
  Future<List<Atendimento>> listar() async {
    final db = await _database.database;

    final resultado = await db.query(
      'atendimentos',
      orderBy: 'realizado_em DESC',
    );

    return resultado
        .map((map) => Atendimento.fromMap(map))
        .toList();
  }

  // READ - Busca por ID
  Future<Atendimento?> buscarPorId(int id) async {
    final db = await _database.database;

    final resultado = await db.query(
      'atendimentos',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (resultado.isEmpty) return null;

    return Atendimento.fromMap(resultado.first);
  }

  // READ - Busca pelo agendamento
  Future<Atendimento?> buscarPorAgendamento(
    int agendamentoId,
  ) async {
    final db = await _database.database;

    final resultado = await db.query(
      'atendimentos',
      where: 'agendamento_id = ?',
      whereArgs: [agendamentoId],
      limit: 1,
    );

    if (resultado.isEmpty) return null;

    return Atendimento.fromMap(resultado.first);
  }

  // UPDATE
  Future<int> atualizar(Atendimento atendimento) async {
    if (atendimento.id == null) {
      throw ArgumentError('Atendimento sem ID.');
    }

    final db = await _database.database;

    // O vínculo com o agendamento é preservado.
    return db.update(
      'atendimentos',
      {
        'realizado_em':
            atendimento.realizadoEm.toIso8601String(),
        'observacao_administrativa':
            atendimento.observacaoAdministrativa,
      },
      where: 'id = ? AND agendamento_id = ?',
      whereArgs: [
        atendimento.id,
        atendimento.agendamentoId,
      ],
    );
  }

  // DELETE
  Future<int> excluir(int id) async {
    final db = await _database.database;

    return db.transaction((txn) async {
      final registros = await txn.query(
        'atendimentos',
        columns: ['agendamento_id'],
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (registros.isEmpty) return 0;

      final agendamentoId =
          registros.first['agendamento_id'] as int;

      final pagamentos = await txn.query(
        'pagamentos',
        columns: ['id'],
        where: 'atendimento_id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (pagamentos.isNotEmpty) {
        throw StateError(
          'Não é possível excluir um atendimento '
          'que possui pagamentos vinculados.',
        );
      }

      final excluidos = await txn.delete(
        'atendimentos',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (excluidos > 0) {
        await txn.update(
          'agendamentos',
          {'status': 'agendado'},
          where: 'id = ? AND status = ?',
          whereArgs: [agendamentoId, 'concluido'],
        );
      }

      return excluidos;
    });
  }
}
