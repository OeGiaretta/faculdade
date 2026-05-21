# 📄 SeeNote API

API REST desenvolvida em Dart para gerenciamento de notas fiscais, utilizando arquitetura em camadas, SQLite e padronização de respostas HTTP.

---

# 🚀 Tecnologias Utilizadas

- Dart
- Shelf
- Shelf Router
- SQLite
- sqlite3

---

# 🏗️ Arquitetura do Projeto

O projeto utiliza uma arquitetura em camadas para separar responsabilidades e facilitar manutenção.

```txt
Routes
   ↓
Controller
   ↓
Service
   ↓
SQLite Database
````

---

# 📂 Estrutura do Projeto

```txt
seenote/
│
├── bin/
│   └── server.dart
│
├── lib/
│   ├── controllers/
│   │   └── nota_controller.dart
│   │
│   ├── services/
│   │   └── nota_service.dart
│   │
│   ├── routes/
│   │   └── routes.dart
│   │
│   ├── models/
│   │   └── api_response.dart
│   │
│   ├── database/
│   │   └── database.dart
│   │
│   └── data/
│
├── pubspec.yaml
└── README.md

```
```

# ⚙️ Como Executar o Projeto

## 1. Instalar dependências
```dart
dart pub get
```
---

## 2. Executar servidor

```dart
dart run bin/server.dart
```

---

## 3. Servidor disponível em

```txt
http://localhost:8080
```

---

# 💾 Banco de Dados

O projeto utiliza SQLite.

O banco é criado automaticamente:

```txt
seenote.db
```

Tabela criada automaticamente:

```sql
CREATE TABLE notas (
    numero TEXT PRIMARY KEY,
    empresa TEXT,
    cnpj TEXT,
    valor REAL,
    data TEXT
);
```

---

# 📌 Endpoints da API

---

# ✅ GET /notas

Lista todas as notas fiscais.

## Requisição

```http
GET /notas
```

---

## Resposta

```json
{
  "success": true,
  "message": "Notas listadas com sucesso",
  "data": []
}
```

---

# ✅ GET /nota/<id>

Busca uma nota fiscal pelo número.

## Requisição

```http
GET /nota/1001
```

---

## Resposta

```json
{
  "success": true,
  "message": "Nota encontrada",
  "data": {
    "numero": "1001",
    "empresa": "Mercado Central",
    "cnpj": "12.345.678/0001-99",
    "valor": 249.9,
    "data": "21/05/2026"
  }
}
```

---

# ✅ POST /nota

Cria uma nova nota fiscal.

## Requisição

```http
POST /nota
Content-Type: application/json
```

---

## Body

```json
{
  "numero": "1001",
  "empresa": "Mercado Central",
  "cnpj": "12.345.678/0001-99",
  "valor": 249.90,
  "data": "21/05/2026"
}
```

---

## Resposta

```json
{
  "success": true,
  "message": "Nota criada com sucesso",
  "data": {
    "numero": "1001",
    "empresa": "Mercado Central",
    "cnpj": "12.345.678/0001-99",
    "valor": 249.9,
    "data": "21/05/2026"
  }
}
```

---

# ✅ PUT /nota/<id>

Atualiza uma nota fiscal existente.

## Requisição

```http
PUT /nota/1001
Content-Type: application/json
```

---

## Body

```json
{
  "empresa": "Mercado Atualizado",
  "valor": 500
}
```

---

## Resposta

```json
{
  "success": true,
  "message": "Nota atualizada com sucesso",
  "data": {
    "empresa": "Mercado Atualizado",
    "valor": 500
  }
}
```

---

# ✅ DELETE /nota/<id>

Remove uma nota fiscal.

## Requisição

```http
DELETE /nota/1001
```

---

## Resposta

```json
{
  "success": true,
  "message": "Nota removida com sucesso",
  "data": null
}
```

---

# ❌ Respostas de Erro

## Nota não encontrada

```json
{
  "success": false,
  "message": "Nota não encontrada",
  "data": null
}
```

---

## Campos obrigatórios ausentes

```json
{
  "success": false,
  "message": "Campos obrigatórios: numero, empresa e valor",
  "data": null
}
```

---

# 🧠 Conceitos Aplicados

* REST API
* CRUD
* SQLite
* Arquitetura em camadas
* Service Layer
* Padronização de respostas HTTP
* Separação de responsabilidades
* Persistência de dados

---

# 📚 Objetivo do Projeto

Projeto desenvolvido para fins acadêmicos com objetivo de praticar:

* Desenvolvimento backend com Dart
* Criação de APIs REST
* Integração com banco de dados SQLite
* Arquitetura de software
* Organização de projetos backend

---

# 👨‍💻 Autor

Desenvolvido por ***Eduardo Giaretta***.


