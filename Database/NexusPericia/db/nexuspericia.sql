-- =====================================================
-- BANCO DE DADOS
-- Projeto: NexusPericia
-- PostgreSQL
-- =====================================================

CREATE DATABASE nexuspericia;

-- Conecte no banco antes de executar o restante
-- \c nexuspericia


-- =====================================================
-- TABELA: DELEGACIA
-- =====================================================

CREATE TABLE delegacia (
    id_delegacia SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado VARCHAR(2) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100),
    endereco VARCHAR(200),
    nivel_seguranca INT CHECK (nivel_seguranca BETWEEN 1 AND 5)
);


-- =====================================================
-- TABELA: CASO
-- =====================================================

CREATE TABLE caso (
    id_caso SERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    descricao TEXT,
    data_abertura TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(30) NOT NULL,
    prioridade VARCHAR(20),
    tipo_crime VARCHAR(100),
    delegacia_id INT NOT NULL,

    CONSTRAINT fk_caso_delegacia
        FOREIGN KEY (delegacia_id)
        REFERENCES delegacia(id_delegacia)
);


-- =====================================================
-- TABELA: SUSPEITO
-- =====================================================

CREATE TABLE suspeito (
    id_suspeito SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    endereco VARCHAR(200),
    data_nascimento DATE,
    antecedentes TEXT,
    nivel_risco INT CHECK (nivel_risco BETWEEN 1 AND 5)
);


-- =====================================================
-- TABELA: INVESTIGADOR
-- =====================================================

CREATE TABLE investigador (
    id_investigador SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(50),
    matricula VARCHAR(20) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100),
    nivel_acesso INT CHECK (nivel_acesso BETWEEN 1 AND 5),
    delegacia_id INT NOT NULL,

    CONSTRAINT fk_investigador_delegacia
        FOREIGN KEY (delegacia_id)
        REFERENCES delegacia(id_delegacia)
);


-- =====================================================
-- TABELA: EVIDENCIA
-- =====================================================

CREATE TABLE evidencia (
    id_evidencia SERIAL PRIMARY KEY,
    descricao TEXT NOT NULL,
    tipo VARCHAR(50),
    local_coleta VARCHAR(200),
    data_coleta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(30),
    hash_sha256 VARCHAR(255),
    caso_id INT NOT NULL,

    CONSTRAINT fk_evidencia_caso
        FOREIGN KEY (caso_id)
        REFERENCES caso(id_caso)
);


-- =====================================================
-- TABELA: PERITO
-- =====================================================

CREATE TABLE perito (
    id_perito SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    especialidade VARCHAR(100),
    matricula VARCHAR(20) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100),
    nivel_acesso INT CHECK (nivel_acesso BETWEEN 1 AND 5),
    data_ingresso DATE
);


-- =====================================================
-- TABELA: LAUDO
-- =====================================================

CREATE TABLE laudo (
    id_laudo SERIAL PRIMARY KEY,
    resultado TEXT,
    conclusao TEXT,
    data_emissao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(30),
    observacoes TEXT,
    evidencia_id INT UNIQUE NOT NULL,
    perito_id INT NOT NULL,

    CONSTRAINT fk_laudo_evidencia
        FOREIGN KEY (evidencia_id)
        REFERENCES evidencia(id_evidencia),

    CONSTRAINT fk_laudo_perito
        FOREIGN KEY (perito_id)
        REFERENCES perito(id_perito)
);


-- =====================================================
-- TABELA: CADEIA_CUSTODIA
-- =====================================================

CREATE TABLE cadeia_custodia (
    id_movimentacao SERIAL PRIMARY KEY,
    evidencia_id INT NOT NULL,
    responsavel VARCHAR(100),
    data_movimentacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    local VARCHAR(200),
    observacao TEXT,
    status VARCHAR(30),
    assinatura_hash VARCHAR(255),

    CONSTRAINT fk_cadeia_evidencia
        FOREIGN KEY (evidencia_id)
        REFERENCES evidencia(id_evidencia)
);


-- =====================================================
-- TABELA: CASO_SUSPEITO
-- RELACIONAMENTO N:N
-- =====================================================

CREATE TABLE caso_suspeito (
    id_relacao SERIAL PRIMARY KEY,
    caso_id INT NOT NULL,
    suspeito_id INT NOT NULL,
    envolvimento VARCHAR(100),
    data_associacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    observacao TEXT,
    nivel_suspeita INT CHECK (nivel_suspeita BETWEEN 1 AND 5),
    status VARCHAR(30),

    CONSTRAINT fk_cs_caso
        FOREIGN KEY (caso_id)
        REFERENCES caso(id_caso),

    CONSTRAINT fk_cs_suspeito
        FOREIGN KEY (suspeito_id)
        REFERENCES suspeito(id_suspeito)
);


-- =====================================================
-- TABELA: CASO_INVESTIGADOR
-- RELACIONAMENTO N:N
-- =====================================================

CREATE TABLE caso_investigador (
    id_relacao SERIAL PRIMARY KEY,
    caso_id INT NOT NULL,
    investigador_id INT NOT NULL,
    funcao VARCHAR(100),
    data_designacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(30),
    observacao TEXT,
    prioridade INT CHECK (prioridade BETWEEN 1 AND 5),

    CONSTRAINT fk_ci_caso
        FOREIGN KEY (caso_id)
        REFERENCES caso(id_caso),

    CONSTRAINT fk_ci_investigador
        FOREIGN KEY (investigador_id)
        REFERENCES investigador(id_investigador)
);


-- =====================================================
-- ÍNDICES (MELHOR PERFORMANCE)
-- =====================================================

CREATE INDEX idx_caso_status
ON caso(status);

CREATE INDEX idx_evidencia_tipo
ON evidencia(tipo);

CREATE INDEX idx_suspeito_cpf
ON suspeito(cpf);

CREATE INDEX idx_investigador_matricula
ON investigador(matricula);

CREATE INDEX idx_perito_matricula
ON perito(matricula);


-- =====================================================
-- FIM DO SCRIPT
-- =====================================================