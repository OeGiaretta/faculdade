
import '../core/database/app_database.dart';
import '../models/agendamento.dart';

class AgendamentoRepository {
  final AppDatabase _database = AppDatabase.instance;

  // CREATE
  Future<int> inserir(Agendamento agendamento) async {
    final db = await _database.database;

    if (!agendamento.dataHoraFim.isAfter(
      agendamento.dataHoraInicio,
    )) {
      throw ArgumentError(
        'O horário final deve ser posterior ao inicial.',
      );
    }

    return db.insert(
      'agendamentos',
      agendamento.toMap(),
    );
  }

  // READ
  Future<List<Agendamento>> listar() async {
    final db = await _database.database;

    final resultado = await db.query(
      'agendamentos',
      orderBy: 'data_hora_inicio ASC',
    );

    return resultado
        .map((map) => Agendamento.fromMap(map))
        .toList();
  }

  // READ por paciente
  Future<List<Agendamento>> listarPorPaciente(
    int pacienteId,
  ) async {
    final db = await _database.database;

    final resultado = await db.query(
      'agendamentos',
      where: 'paciente_id = ?',
      whereArgs: [pacienteId],
      orderBy: 'data_hora_inicio ASC',
    );

    return resultado
        .map((map) => Agendamento.fromMap(map))
        .toList();
  }

  // READ por ID
  Future<Agendamento?> buscarPorId(int id) async {
    final db = await _database.database;

    final resultado = await db.query(
      'agendamentos',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (resultado.isEmpty) return null;

    return Agendamento.fromMap(resultado.first);
  }

  // UPDATE
  Future<int> atualizar(Agendamento agendamento) async {
    if (agendamento.id == null) {
      throw ArgumentError('Agendamento sem ID.');
    }

    if (!agendamento.dataHoraFim.isAfter(
      agendamento.dataHoraInicio,
    )) {
      throw ArgumentError(
        'O horário final deve ser posterior ao inicial.',
      );
    }

    final db = await _database.database;

    return db.update(
      'agendamentos',
      agendamento.toMap(),
      where: 'id = ?',
      whereArgs: [agendamento.id],
    );
  }

  // UPDATE status
  Future<int> atualizarStatus(
    int id,
    String status,
  ) async {
    const statusPermitidos = {
      'agendado',
      'concluido',
      'cancelado',
      'nao_compareceu',
    };

    if (!statusPermitidos.contains(status)) {
      throw ArgumentError('Status inválido.');
    }

    final db = await _database.database;

    return db.update(
      'agendamentos',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE
  Future<int> excluir(int id) async {
    final db = await _database.database;

    return db.delete(
      'agendamentos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
