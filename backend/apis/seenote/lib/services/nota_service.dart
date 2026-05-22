import 'package:sqlite3/sqlite3.dart';

class NotaService {
  final Database db;

  NotaService(this.db);

  List<Map<String, dynamic>> getAll() {
    final result = db.select('SELECT * FROM notas');

    return result.map((row) => {
      "numero": row["numero"],
      "empresa": row["empresa"],
      "cnpj": row["cnpj"],
      "valor": row["valor"],
      "data": row["data"],
    }).toList();
  }

  Map<String, dynamic>? getById(String id) {
    final result = db.select(
      'SELECT * FROM notas WHERE numero = ?',
      [id],
    );

    if (result.isEmpty) return null;

    final row = result.first;

    return {
      "numero": row["numero"],
      "empresa": row["empresa"],
      "cnpj": row["cnpj"],
      "valor": row["valor"],
      "data": row["data"],
    };
  }

  void create(Map data) {
    db.execute('''
      INSERT OR REPLACE INTO notas
      (numero, empresa, cnpj, valor, data)
      VALUES (?, ?, ?, ?, ?)
    ''', [
      data['numero'],
      data['empresa'],
      data['cnpj'],
      data['valor'],
      data['data']
    ]);
  }

  void update(String id, Map data) {
    db.execute('''
      UPDATE notas
      SET empresa = ?, cnpj = ?, valor = ?, data = ?
      WHERE numero = ?
    ''', [
      data['empresa'],
      data['cnpj'],
      data['valor'],
      data['data'],
      id
    ]);
  }

  void delete(String id) {
    db.execute(
      'DELETE FROM notas WHERE numero = ?',
      [id],
    );
  }
}