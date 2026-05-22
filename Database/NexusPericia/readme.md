# Documentação do Projeto — NexusPerícia

## Sistema de Investigação Criminal e Perícia Digital

---

# 1. Visão Geral

O **NexusPerícia** é um sistema desenvolvido para auxiliar no gerenciamento de investigações criminais e processos de perícia digital.

O sistema permite controlar:
- casos criminais
- suspeitos
- investigadores
- evidências
- laudos periciais
- cadeia de custódia

O projeto foi modelado utilizando banco de dados relacional com PostgreSQL.

---

# 2. Objetivo do Sistema

O objetivo principal do sistema é centralizar e organizar informações relacionadas a investigações criminais, garantindo:
- integridade dos dados
- rastreabilidade das evidências
- controle de acesso
- organização dos casos
- histórico das movimentações

---

# 3. Tecnologias Utilizadas

| Tecnologia | Finalidade |
|---|---|
| PostgreSQL | Banco de dados relacional |
| pgAdmin 4 | Administração do banco |
| SQL | Criação e manipulação do banco |
| dbdiagram.io | Modelagem DER |

---

# 4. Requisitos do Projeto

O sistema foi desenvolvido atendendo os seguintes requisitos acadêmicos:
- mínimo de 5 entidades
- mínimo de 7 atributos por entidade
- utilização de relacionamentos
- utilização de chaves primárias e estrangeiras
- implementação em banco de dados real

---

# 5. Estrutura do Banco de Dados

O banco foi modelado utilizando o paradigma relacional.

---

# 6. Entidades do Sistema

---

## 6.1 Delegacia

Responsável pelo gerenciamento dos casos e investigadores.

### Principais atributos:
- id_delegacia
- nome
- cidade
- estado
- telefone
- email
- endereco
- nivel_seguranca

---

## 6.2 Caso

Representa uma investigação criminal.

### Principais atributos:
- id_caso
- titulo
- descricao
- data_abertura
- status
- prioridade
- tipo_crime
- delegacia_id

---

## 6.3 Suspeito

Representa indivíduos investigados.

### Principais atributos:
- id_suspeito
- nome
- cpf
- telefone
- endereco
- data_nascimento
- antecedentes
- nivel_risco

---

## 6.4 Investigador

Responsável pela investigação dos casos.

### Principais atributos:
- id_investigador
- nome
- cargo
- matricula
- telefone
- email
- nivel_acesso
- delegacia_id

---

## 6.5 Evidência

Representa provas coletadas.

### Principais atributos:
- id_evidencia
- descricao
- tipo
- local_coleta
- data_coleta
- status
- hash_sha256
- caso_id

---

## 6.6 Perito

Especialista responsável pela análise técnica das evidências.

### Principais atributos:
- id_perito
- nome
- especialidade
- matricula
- telefone
- email
- nivel_acesso
- data_ingresso

---

## 6.7 Laudo

Resultado técnico da análise pericial.

### Principais atributos:
- id_laudo
- resultado
- conclusao
- data_emissao
- status
- observacoes
- evidencia_id
- perito_id

---

## 6.8 Cadeia de Custódia

Controla a movimentação das evidências.

### Principais atributos:
- id_movimentacao
- evidencia_id
- responsavel
- data_movimentacao
- local
- observacao
- status
- assinatura_hash

---

## 6.9 Caso_Suspeito

Tabela intermediária responsável pelo relacionamento N:N entre casos e suspeitos.

---

## 6.10 Caso_Investigador

Tabela intermediária responsável pelo relacionamento N:N entre casos e investigadores.

---

# 7. Relacionamentos

## Relacionamentos 1:N

| Entidade Origem | Entidade Destino |
|---|---|
| Delegacia | Caso |
| Delegacia | Investigador |
| Caso | Evidência |
| Evidência | Cadeia_Custodia |
| Perito | Laudo |

---

## Relacionamentos N:N

| Entidades |
|---|
| Caso ↔ Suspeito |
| Caso ↔ Investigador |

---

# 8. Regras de Negócio

O sistema possui algumas regras importantes:

- Um caso pertence a apenas uma delegacia.
- Um caso pode possuir várias evidências.
- Uma evidência pode gerar apenas um laudo.
- Um suspeito pode estar associado a vários casos.
- Um investigador pode atuar em vários casos.
- Toda movimentação de evidência deve ser registrada na cadeia de custódia.

---

# 9. Integridade dos Dados

Foram utilizados mecanismos do PostgreSQL para garantir segurança e integridade.

## Recursos utilizados:
- PRIMARY KEY
- FOREIGN KEY
- UNIQUE
- CHECK
- NOT NULL

---

# 10. Segurança do Sistema

O projeto implementa:
- rastreamento de evidências
- controle de movimentações
- validação de acesso
- identificação única de registros
- armazenamento de hash SHA256 para evidências digitais

---

# 11. Exemplos de Consultas SQL

## Consultar casos e suspeitos

```sql
SELECT
    c.titulo,
    s.nome
FROM caso c
JOIN caso_suspeito cs
ON cs.caso_id = c.id_caso
JOIN suspeito s
ON s.id_suspeito = cs.suspeito_id;
````

---

## Consultar laudos emitidos

``````sql
SELECT
    l.id_laudo,
    p.nome AS perito,
    e.tipo AS evidencia
FROM laudo l
JOIN perito p
ON p.id_perito = l.perito_id
JOIN evidencia e
ON e.id_evidencia = l.evidencia_id;
``````

---

# 12. Objetivos Acadêmicos Alcançados

O projeto demonstra:

* modelagem relacional
* normalização
* uso de PostgreSQL
* implementação de relacionamentos complexos
* uso de tabelas intermediárias
* integridade referencial
* modelagem profissional

---

# 13. Possíveis Expansões Futuras

O sistema poderá futuramente incluir:

* autenticação de usuários
* painel administrativo
* API REST
* upload de arquivos
* assinatura digital
* dashboard investigativo
* integração com inteligência artificial

---

# 14. Conclusão

O projeto NexusPerícia foi desenvolvido com foco em simular um sistema real utilizado em ambientes de investigação criminal e perícia digital.

Além de atender os requisitos acadêmicos, o sistema apresenta uma estrutura profissional, organizada e escalável, demonstrando conceitos avançados de modelagem de banco de dados e integridade relacional.
