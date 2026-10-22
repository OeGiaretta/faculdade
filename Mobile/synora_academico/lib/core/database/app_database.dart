
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'synora_academico.db');

    return openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE psicologos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        crp TEXT,
        email TEXT,
        telefone TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE pacientes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        psicologo_id INTEGER NOT NULL,
        nome TEXT NOT NULL,
        telefone TEXT,
        email TEXT,
        data_nascimento TEXT,
        ativo INTEGER NOT NULL DEFAULT 1
          CHECK (ativo IN (0, 1)),
        criado_em TEXT NOT NULL
          DEFAULT CURRENT_TIMESTAMP,

        FOREIGN KEY (psicologo_id)
          REFERENCES psicologos(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE agendamentos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        paciente_id INTEGER NOT NULL,
        data_hora_inicio TEXT NOT NULL,
        data_hora_fim TEXT NOT NULL,
        modalidade TEXT NOT NULL DEFAULT 'presencial'
          CHECK (modalidade IN ('presencial', 'online')),
        status TEXT NOT NULL DEFAULT 'agendado'
          CHECK (status IN (
            'agendado',
            'concluido',
            'cancelado',
            'nao_compareceu'
          )),

        FOREIGN KEY (paciente_id)
          REFERENCES pacientes(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE atendimentos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        agendamento_id INTEGER NOT NULL UNIQUE,
        realizado_em TEXT NOT NULL,
        observacao_administrativa TEXT,

        FOREIGN KEY (agendamento_id)
          REFERENCES agendamentos(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE pagamentos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        atendimento_id INTEGER NOT NULL,
        valor REAL NOT NULL CHECK (valor >= 0),
        data_pagamento TEXT,
        forma_pagamento TEXT,
        status TEXT NOT NULL DEFAULT 'pendente'
          CHECK (status IN ('pendente', 'pago', 'cancelado')),

        FOREIGN KEY (atendimento_id)
          REFERENCES atendimentos(id)
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_pacientes_psicologo
      ON pacientes(psicologo_id)
    ''');

    await db.execute('''
      CREATE INDEX idx_agendamentos_paciente
      ON agendamentos(paciente_id)
    ''');

    await db.execute('''
      CREATE INDEX idx_agendamentos_inicio
      ON agendamentos(data_hora_inicio)
    ''');

    await db.execute('''
      CREATE INDEX idx_pagamentos_atendimento
      ON pagamentos(atendimento_id)
    ''');
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
