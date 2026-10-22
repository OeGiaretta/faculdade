
import '../core/database/app_database.dart';
import '../models/paciente.dart';

class PacienteRepository {
  final AppDatabase _database = AppDatabase.instance;

  Future<int> inserir(Paciente paciente) async {
    final db = await _database.database;

    return db.insert(
      'pacientes',
      paciente.toMap(),
    );
  }

  Future<List<Paciente>> listar(int psicologoId) async {
    final db = await _database.database;

    final resultado = await db.query(
      'pacientes',
      where: 'psicologo_id = ?',
      whereArgs: [psicologoId],
      orderBy: 'nome ASC',
    );

    return resultado.map(Paciente.fromMap).toList();
  }

  Future<Paciente?> buscarPorId(int id) async {
    final db = await _database.database;

    final resultado = await db.query(
      'pacientes',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (resultado.isEmpty) return null;

    return Paciente.fromMap(resultado.first);
  }

  Future<int> atualizar(Paciente paciente) async {
    if (paciente.id == null) {
      throw ArgumentError('Paciente sem ID.');
    }

    final db = await _database.database;

    return db.update(
      'pacientes',
      paciente.toMap(),
      where: 'id = ? AND psicologo_id = ?',
      whereArgs: [paciente.id, paciente.psicologoId],
    );
  }

  Future<int> excluir(int id) async {
    final db = await _database.database;

    return db.delete(
      'pacientes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> inativar(int id) async {
    final db = await _database.database;

    return db.update(
      'pacientes',
      {'ativo': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
