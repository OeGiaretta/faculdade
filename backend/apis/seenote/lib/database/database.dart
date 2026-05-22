import 'package:sqlite3/sqlite3.dart';

class DatabaseService {
  late final Database db;

  DatabaseService() {
    db = sqlite3.open('seenote.db');

    db.execute('''
      CREATE TABLE IF NOT EXISTS notas (
        numero TEXT PRIMARY KEY,
        empresa TEXT,
        cnpj TEXT,
        valor REAL,
        data TEXT
      );
    ''');
  }
}