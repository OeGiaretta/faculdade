
import '../core/database/app_database.dart';
import '../models/psicologo.dart';

class PsicologoRepository {
  final AppDatabase _database = AppDatabase.instance;

  // CREATE - Cadastrar psicólogo
  Future<int> inserir(Psicologo psicologo) async {
    final db = await _database.database;

    return db.insert(
      'psicologos',
      psicologo.toMap(),
    );
  }

  // READ - Buscar primeiro psicólogo cadastrado
  Future<Psicologo?> buscarPrimeiro() async {
    final db = await _database.database;

    final resultado = await db.query(
      'psicologos',
      orderBy: 'id ASC',
      limit: 1,
    );

    if (resultado.isEmpty) return null;

    return Psicologo.fromMap(resultado.first);
  }

  // READ - Buscar psicólogo pelo ID
  Future<Psicologo?> buscarPorId(int id) async {
    final db = await _database.database;

    final resultado = await db.query(
      'psicologos',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (resultado.isEmpty) return null;

    return Psicologo.fromMap(resultado.first);
  }

  // UPDATE - Atualizar dados do psicólogo
  Future<int> atualizar(Psicologo psicologo) async {
    if (psicologo.id == null) {
      throw ArgumentError(
        'Não é possível atualizar um psicólogo sem ID.',
      );
    }

    if (psicologo.nome.trim().isEmpty) {
      throw ArgumentError(
        'O nome do psicólogo não pode estar vazio.',
      );
    }

    final db = await _database.database;

    return db.update(
      'psicologos',
      psicologo.toMap(),
      where: 'id = ?',
      whereArgs: [psicologo.id],
    );
  }
}
