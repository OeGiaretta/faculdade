import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('\nMenu de Cadastros'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),

      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/clientes');
                },

                style: ButtonStyle(
                  minimumSize: WidgetStateProperty.all(const Size(140, 45)),

                  foregroundColor: WidgetStateProperty.resolveWith<Color>((
                    states,
                  ) {
                    if (states.contains(WidgetState.pressed)) {
                      return Colors.white;
                    }

                    return Colors.white;
                  }),

                  backgroundColor: WidgetStateProperty.resolveWith<Color>((
                    states,
                  ) {
                    if (states.contains(WidgetState.pressed)) {
                      return Colors.black;
                    }

                    return Colors.black;
                  }),
                ),

                child: const Text('Clientes'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/produtos');
                },

                style: ButtonStyle(
                  minimumSize: WidgetStateProperty.all(const Size(140, 45)),

                  foregroundColor: WidgetStateProperty.resolveWith<Color>((
                    states,
                  ) {
                    if (states.contains(WidgetState.pressed)) {
                      return Colors.black;
                    }

                    return Colors.black;
                  }),

                  backgroundColor: WidgetStateProperty.resolveWith<Color>((
                    states,
                  ) {
                    if (states.contains(WidgetState.pressed)) {
                      return Colors.yellow;
                    }

                    return Colors.yellow;
                  }),
                ),

                child: const Text('Produtos'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}