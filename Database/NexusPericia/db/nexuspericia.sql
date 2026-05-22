import 'package:postgres/postgres.dart';

class DatabaseService {
  late PostgreSQLConnection db;

  final String host = 'localhost';
  final int port = 5432;
  final String user = 'postgres';
  final String password = '123456';

  final String databaseName = 'nexuspericia';

  Future<void> init() async {
    await _createDatabaseIfNotExists();
    await _connectToDatabase();
    await _createTables();
  }

  // =========================================
  // 1. CRIA BANCO (via postgres padrão)
  // =========================================
  Future<void> _createDatabaseIfNotExists() async {
    final conn = PostgreSQLConnection(
      host,
      port,
      'postgres', // banco padrão administrativo
      username: user,
      password: password,
    );

    await conn.open();

    final result = await conn.query('''
      SELECT 1 FROM pg_database WHERE datname = @name
    ''', substitutionValues: {
      'name': databaseName
    });

    if (result.isEmpty) {
      await conn.execute('CREATE DATABASE $databaseName');
      print('Banco $databaseName criado!');
    } else {
      print('Banco já existe');
    }

    await conn.close();
  }

  // =========================================
  // 2. CONECTA NO BANCO PRINCIPAL
  // =========================================
  Future<void> _connectToDatabase() async {
    db = PostgreSQLConnection(
      host,
      port,
      databaseName,
      username: user,
      password: password,
    );

    await db.open();
    print('Conectado ao banco $databaseName');
  }

  // =========================================
  // 3. CRIA TODAS AS TABELAS
  // =========================================
  Future<void> _createTables() async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS delegacia (
        id_delegacia SERIAL PRIMARY KEY,
        nome VARCHAR(100) NOT NULL,
        cidade VARCHAR(100) NOT NULL,
        estado VARCHAR(2) NOT NULL,
        telefone VARCHAR(20),
        email VARCHAR(100),
        endereco VARCHAR(200),
        nivel_seguranca INT CHECK (nivel_seguranca BETWEEN 1 AND 5)
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS caso (
        id_caso SERIAL PRIMARY KEY,
        titulo VARCHAR(200) NOT NULL,
        descricao TEXT,
        data_abertura TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        status VARCHAR(30) NOT NULL,
        prioridade VARCHAR(20),
        tipo_crime VARCHAR(100),
        delegacia_id INT NOT NULL,
        FOREIGN KEY (delegacia_id) REFERENCES delegacia(id_delegacia)
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS suspeito (
        id_suspeito SERIAL PRIMARY KEY,
        nome VARCHAR(100) NOT NULL,
        cpf VARCHAR(14) UNIQUE NOT NULL,
        telefone VARCHAR(20),
        endereco VARCHAR(200),
        data_nascimento DATE,
        antecedentes TEXT,
        nivel_risco INT CHECK (nivel_risco BETWEEN 1 AND 5)
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS investigador (
        id_investigador SERIAL PRIMARY KEY,
        nome VARCHAR(100) NOT NULL,
        cargo VARCHAR(50),
        matricula VARCHAR(20) UNIQUE NOT NULL,
        telefone VARCHAR(20),
        email VARCHAR(100),
        nivel_acesso INT CHECK (nivel_acesso BETWEEN 1 AND 5),
        delegacia_id INT NOT NULL,
        FOREIGN KEY (delegacia_id) REFERENCES delegacia(id_delegacia)
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS evidencia (
        id_evidencia SERIAL PRIMARY KEY,
        descricao TEXT NOT NULL,
        tipo VARCHAR(50),
        local_coleta VARCHAR(200),
        data_coleta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        status VARCHAR(30),
        hash_sha256 VARCHAR(255),
        caso_id INT NOT NULL,
        FOREIGN KEY (caso_id) REFERENCES caso(id_caso)
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS perito (
        id_perito SERIAL PRIMARY KEY,
        nome VARCHAR(100) NOT NULL,
        especialidade VARCHAR(100),
        matricula VARCHAR(20) UNIQUE NOT NULL,
        telefone VARCHAR(20),
        email VARCHAR(100),
        nivel_acesso INT CHECK (nivel_acesso BETWEEN 1 AND 5),
        data_ingresso DATE
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS laudo (
        id_laudo SERIAL PRIMARY KEY,
        resultado TEXT,
        conclusao TEXT,
        data_emissao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        status VARCHAR(30),
        observacoes TEXT,
        evidencia_id INT UNIQUE NOT NULL,
        perito_id INT NOT NULL,
        FOREIGN KEY (evidencia_id) REFERENCES evidencia(id_evidencia),
        FOREIGN KEY (perito_id) REFERENCES perito(id_perito)
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS cadeia_custodia (
        id_movimentacao SERIAL PRIMARY KEY,
        evidencia_id INT NOT NULL,
        responsavel VARCHAR(100),
        data_movimentacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        local VARCHAR(200),
        observacao TEXT,
        status VARCHAR(30),
        assinatura_hash VARCHAR(255),
        FOREIGN KEY (evidencia_id) REFERENCES evidencia(id_evidencia)
      );
    ''');

    print('Todas as tabelas foram criadas!');
  }

  Future<void> close() async {
    await db.close();
  }
}