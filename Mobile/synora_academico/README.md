# Synora Acadêmico

**Gestão de consultório psicológico em um aplicativo Android, com dados armazenados localmente no dispositivo.**

O **Synora Acadêmico** é um projeto acadêmico desenvolvido com **Flutter e Dart** para auxiliar na organização de pacientes, agendamentos, atendimentos e pagamentos de um consultório psicológico individual. Os registros são mantidos em um banco **SQLite local**, permitindo o uso das funções de gestão sem conexão com a internet.

> **Atenção:** protótipo para fins acadêmicos e demonstração. Utilize dados fictícios. Não é indicado para armazenar dados reais ou sensíveis de pacientes sem uma avaliação adequada de segurança, privacidade e conformidade com a LGPD.

## 📱 Baixar para Android

[![Baixar APK](https://img.shields.io/badge/Download-Synora%20APK-587C78?style=for-the-badge&logo=android&logoColor=white)](https://github.com/OeGiaretta/faculdade/releases/download/synora-v1.0.0/Synora.apk)

**[Acessar a versão mais recente e baixar o APK](https://github.com/OeGiaretta/Synora-Academico/releases/latest)**

1. Acesse o link acima.
2. Em **Assets**, baixe o arquivo `.apk` da versão disponível.
3. Abra o arquivo no dispositivo Android e, se solicitado, autorize a instalação a partir dessa origem.
4. Conclua a instalação e abra o Synora.

> O download estará disponível depois que a primeira **GitHub Release** for publicada com o APK anexado. O link aponta para a página da versão mais recente e não precisa ser alterado a cada atualização.

## ✨ Funcionalidades

### Painel inicial (Dashboard)
- Visão das consultas agendadas para hoje.
- Consulta dos agendamentos dos próximos sete dias.
- Resumo de agendamentos por status.
- Identificação de consultas **agendadas, concluídas, canceladas e não comparecimentos**.
- Acesso rápido aos módulos do aplicativo.

### Pacientes
- Cadastro e listagem de pacientes.
- Pesquisa, visualização e edição de informações.
- Controle de pacientes ativos e inativos.

### Agenda
- Cadastro e acompanhamento de consultas.
- Agendamentos presenciais e online.
- Controle de horários e status.
- Visualização de consultas canceladas para preservar a programação.

### Atendimentos
- Registro administrativo de atendimentos realizados.
- Associação do atendimento a um agendamento.
- Atualização do agendamento para **concluído** após o registro do atendimento.

### Financeiro
- Registro e acompanhamento de pagamentos.
- Controle de valores, formas de pagamento e status.
- Consulta das informações financeiras registradas.

### Perfil profissional
- Cadastro inicial do psicólogo.
- Visualização e edição dos dados profissionais.

**Estado atual da autenticação:** existe uma tela de entrada e um botão **Sair**, mas a autenticação local por senha e o encerramento real de sessão ainda não foram implementados. Não considere a tela de entrada uma proteção de acesso aos dados.

## 🛠️ Tecnologias

- **Flutter** e **Dart** — interface e lógica do aplicativo.
- **SQLite (`sqflite`)** — persistência local de dados.
- **`path`** — manipulação de caminhos do banco.
- **`intl`** — formatação de datas e horários.
- **`flutter_launcher_icons`** — geração do ícone do aplicativo.

## 🗂️ Organização do código

```text
lib/
├── main.dart
├── core/
│   └── database/
│       └── app_database.dart
├── models/
├── repositories/
└── features/
    ├── dashboard/
    ├── pacientes/
    ├── agenda/
    ├── atendimentos/
    ├── financeiro/
    └── perfil/
```

## 🚀 Executar o projeto

**Pré-requisitos:** Flutter SDK configurado, Android SDK e um dispositivo ou emulador Android.

```bash
git clone https://github.com/OeGiaretta/Synora-Academico.git
cd Synora-Academico
flutter pub get
flutter analyze
flutter run
```

O banco SQLite é criado localmente quando o aplicativo é iniciado pela primeira vez.

## 📦 Gerar o APK

Na raiz do projeto, execute:

```bash
flutter pub get
flutter build apk --release
```

O arquivo gerado estará em:

```text
build/app/outputs/flutter-apk/app-release.apk
```

Antes de distribuir, teste a versão **release** em um dispositivo Android. O APK deve ser publicado na seção **Releases** do GitHub, não necessariamente versionado junto com o código-fonte.

### Publicar uma versão para download

1. Acesse **Releases → Draft a new release** no repositório.
2. Crie uma tag, por exemplo, `v1.0.0`.
3. Informe o título **Synora Acadêmico v1.0.0**.
4. Anexe o APK compilado na área **Assets**.
5. Publique a Release.

Após isso, o botão de download no início deste README levará à versão mais recente.

## 🔒 Privacidade e armazenamento

- Os dados ficam no **SQLite do próprio dispositivo**.
- Não há sincronização em nuvem nesta versão.
- Cada instalação possui seus próprios registros; eles não são compartilhados automaticamente entre aparelhos.
- Desinstalar o aplicativo pode apagar os dados locais. Faça backup antes de remover o aplicativo.
- Por se tratar de um protótipo acadêmico sem autenticação local efetiva, **não utilize dados reais de pacientes**.

## 🧭 Próximas melhorias

- Autenticação local por senha e logout real.
- Proteção aprimorada dos dados armazenados.
- Backup e restauração dos registros.
- Melhorias de navegação e visualização da agenda.

## 👨‍💻 Desenvolvimento

Projeto acadêmico de **Análise e Desenvolvimento de Sistemas**, desenvolvido por [OeGiaretta](https://github.com/OeGiaretta).

---

**Synora Acadêmico** — organização da rotina profissional em um só lugar.
