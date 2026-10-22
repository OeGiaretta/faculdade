
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/database/app_database.dart';
import 'features/dashboard/dashboard_page.dart';
import 'features/perfil/entrada_page.dart';
import 'features/perfil/inicializacao_page.dart';

Future<void> main() async {
  // Inicializa os componentes do Flutter.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa a formatação de datas em português.
  await initializeDateFormatting('pt_BR', null);

  // Inicializa o banco de dados SQLite local.
  await AppDatabase.instance.database;

  // Inicia o aplicativo.
  runApp(const SynoraApp());
}

class SynoraApp extends StatelessWidget {
  const SynoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Synora Acadêmico',
      debugShowCheckedModeBanner: false,

      // Tema principal do Synora.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF587C78),
        ),
        useMaterial3: true,
      ),

      // Tela responsável por verificar o cadastro inicial.
      home: const InicializacaoPage(),

      // Rotas de navegação.
      routes: {
        '/dashboard': (context) => const DashboardPage(),
        '/entrada': (context) => const EntradaPage(),
      },
    );
  }
}
