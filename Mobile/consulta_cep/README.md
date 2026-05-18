# Consulta CEP em Dart

Projeto simples desenvolvido em Dart consumindo a API do ViaCEP para consultar informações de um CEP diretamente pelo terminal.

## Tecnologias utilizadas

- Dart
- Package HTTP
- API ViaCEP

## Funcionalidades

- Consulta de CEP
- Exibição de:
  - CEP
  - Logradouro
  - Complemento
  - Bairro
  - Cidade
  - Estado
  - DDD

## Instalação

Clone o repositório:

```bash
git clone <url-do-repositorio>
```

Entre na pasta do projeto:

```bash
cd consulta_cep
```

Instale as dependências:

```bash
dart pub get
```

## Executando o projeto

```bash
dart run
```

## Exemplo de uso

```text
Digite um CEP:
85960000

===== DADOS DO CEP =====
CEP: 85960-000
Logradouro:
Complemento:
Bairro: Centro
Cidade: Marechal Cândido Rondon
Estado: PR
DDD: 45
```

## Estrutura do projeto

```text
consulta_cep/
│
├── bin/
│   └── consulta_cep.dart
│
├── pubspec.yaml
└── README.md
```

## API utilizada

ViaCEP:
https://viacep.com.br
