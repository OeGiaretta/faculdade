# 📚 Sistema de Biblioteca  
## Escola Monteiro Lobato

---

## 1. Descrição do Problema

A Escola Monteiro Lobato, que atende alunos do ensino fundamental e ensino médio, possui uma biblioteca com:

- Livros
- Periódicos (revistas)
- Filmes (DVD)

Atualmente, o controle é realizado manualmente, por meio de anotações em um caderno, registrando quem realizou cada empréstimo.

Esse modelo manual pode gerar:

- Perda de informações
- Erros no controle de prazos
- Dificuldade no cálculo de multas
- Falta de controle da disponibilidade dos itens
- Ausência de relatórios organizados

---

## 2. Objetivo do Sistema

Desenvolver um sistema informatizado para:

- Gerenciar o acervo da biblioteca
- Cadastrar usuários
- Controlar empréstimos e devoluções
- Aplicar regras de prazo por categoria
- Gerar multas por atraso
- Controlar disponibilidade de itens

---

## 3. Stakeholders

- Bibliotecária (ou substituto)
- Professores
- Alunos do ensino fundamental
- Alunos do ensino médio
- Desenvolvedores do sistema

---

## 4. Escopo do Sistema

### ✅ Incluído

- Cadastro de livros
- Cadastro de revistas
- Cadastro de filmes (DVD)
- Cadastro de usuários
- Registro de empréstimos presenciais
- Registro de devoluções
- Controle de prazo por categoria
- Cálculo automático de multa
- Emissão de recibo (se implementado)
- Classificação por categoria (História, Ciências, Gerais)
- Controle de quantidade disponível

### ❌ Fora do Escopo

- Empréstimos online
- Reserva remota
- Biblioteca digital
- Login para alunos
- Aplicativo mobile

---

## 5. Requisitos Funcionais (RF)

### Cadastro de Itens

RF01 – O sistema deve permitir cadastrar livros.  
RF02 – O sistema deve permitir cadastrar revistas.  
RF03 – O sistema deve permitir cadastrar filmes (DVD).  
RF04 – O sistema deve permitir classificar itens por categoria (História, Ciências, Gerais).  
RF05 – O sistema deve controlar quantidade/unidades disponíveis.  

---

### Cadastro de Usuários

RF06 – O sistema deve permitir cadastrar usuários.  
RF07 – O cadastro de usuário deve conter:

- ID Usuário
- Nome
- CPF
- Endereço
- Telefone

---

### Empréstimos

RF08 – O sistema deve registrar empréstimos realizados presencialmente.  
RF09 – O sistema deve registrar devoluções.  
RF10 – O sistema deve alterar automaticamente o status do item para:
- "Emprestado"
- "Livre para empréstimo"

RF11 – O sistema deve aplicar prazo de devolução conforme categoria:
- Livro
- Revista
- Filme

RF12 – O sistema deve calcular multa automaticamente ao ultrapassar o prazo.  

RF13 – O sistema deve emitir recibo de multa (se implementado).

---

## 6. Requisitos Não Funcionais (RNF)

RNF01 – O sistema deve ser utilizado apenas na biblioteca (uso local).  
RNF02 – O sistema deve possuir login e senha apenas para desenvolvedores/administradores.  
RNF03 – O sistema deve armazenar dados em banco de dados persistente.  
RNF04 – O sistema deve garantir integridade das informações.  
RNF05 – O sistema deve permitir substituição da bibliotecária sem perda de dados.  

---

## 7. Regras de Negócio (RN)

RN01 – O empréstimo só pode ser realizado presencialmente na biblioteca.  
RN02 – Cada categoria (Livro, Revista, Filme) possui prazo específico de devolução.  
RN03 – Caso o prazo seja ultrapassado, será gerada multa.  
RN04 – Um item só pode ser emprestado se estiver com status "Livre para empréstimo".  
RN05 – O sistema deve controlar a quantidade disponível de cada item.

---

## 8. Modelagem de Dados (Base Inicial)

### 📘 Livro

- ID Item
- Título
- Autor
- Editora
- Ano de publicação
- Status
- Quantidade

### 📖 Revista

- ID Item
- Número da revista
- Ano de publicação
- Status
- Quantidade

### 🎬 Filme

- ID Item
- Título
- Ano 
- Estudio
- Diretor
- Status
- Quantidade

### 👤 Usuário

- ID Usuário
- Nome
- CPF
- Endereço
- Telefone

---

## 9. Sugestão de Entidade de Controle

### 📄 Empréstimo

- ID Empréstimo
- ID Usuário
- ID Item
- Data Empréstimo
- Data Prevista de Devolução
- Data Devolução
- Valor Multa