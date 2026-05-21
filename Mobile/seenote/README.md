# 📄 SeeNote API

API REST simples desenvolvida em **Dart** usando `Shelf` e `Shelf Router`, com foco em simulação de um sistema de **notas fiscais (CRUD)**.

---

## 🚀 Sobre o projeto

O **SeeNote API** é uma API educacional criada para praticar conceitos de:

* Criação de APIs REST
* Manipulação de JSON
* CRUD (Create, Read, Update, Delete)
* Status HTTP
* Rotas dinâmicas
* Estrutura básica de backend

O sistema simula um gerenciador de notas fiscais.

---

## 🧠 Tecnologias utilizadas

* Dart
* Shelf (HTTP server)
* Shelf Router
* JSON (dart:convert)

---

## 📌 Funcionalidades

### 🔹 Status da API

```http
GET /
```

Resposta:

```txt
SeeNote API Online
```

---

### 🔹 Listar todas as notas

```http
GET /notas
```

Retorna todas as notas cadastradas.

---

### 🔹 Buscar nota por ID

```http
GET /nota/<id>
```

Exemplo:

```http
GET /nota/1001
```

Resposta:

```json
{
  "numero": "1001",
  "empresa": "Mercado Central",
  "cnpj": "12.345.678/0001-99",
  "valor": 249.9,
  "data": "21/05/2026"
}
```

---

### 🔹 Criar nova nota

```http
POST /nota
```

Body:

```json
{
  "numero": "1004",
  "empresa": "Loja Exemplo",
  "cnpj": "11.222.333/0001-44",
  "valor": 99.90,
  "data": "21/05/2026"
}
```

Respostas:

* `201` → criado com sucesso
* `400` → campos inválidos
* `409` → nota já existe

---

### 🔹 Atualizar nota

```http
PUT /nota/<id>
```

Atualiza parcialmente ou totalmente uma nota existente.

---

### 🔹 Deletar nota

```http
DELETE /nota/<id>
```

Remove uma nota pelo ID.

---

## 📁 Estrutura do projeto

```txt
seenote/
├── bin/
│   └── server.dart
├── lib/
│   └── data/
│       └── notas.dart
├── pubspec.yaml
└── README.md
```

---

## ⚙️ Como executar o projeto

### 1. Instalar dependências

```bash
dart pub get
```

### 2. Rodar o servidor

```bash
dart run bin/server.dart
```

### 3. Acessar API

```
http://localhost:8080
```

---

## 🧪 Exemplo de teste (curl)

```bash
curl http://localhost:8080/notas
```

---

## 📊 Status do projeto

✔ API funcionando
✔ CRUD completo
✔ JSON estruturado
✔ Rotas REST
✔ Validação básica
✔ Simulação de sistema fiscal

---

## 🚀 Próximos passos (evolução futura)

* Integração com SQLite (persistência real)
* Separação em camadas (controller/service)
* Melhor padronização de respostas
* Autenticação básica (JWT)
* Deploy da API

---

## 👨‍💻 Autor

Projeto desenvolvido para fins educacionais no estudo de APIs com Dart.
