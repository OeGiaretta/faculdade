import 'package:flutter/material.dart';
import 'package:menudecadastros/menu_page.dart';
import 'package:menudecadastros/clientes_page.dart';
import 'package:menudecadastros/produtos_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu de Cadastros',
      theme: ThemeData(fontFamily: 'Poppins'),

      routes: {
        '/home': (context) => const MenuPage(),
        '/clientes': (context) => const ClientesPage(),
        '/produtos': (context) => const ProdutosPage(),
      },
      
      debugShowCheckedModeBanner: false,
      home: MenuPage(),
    );
  }
}