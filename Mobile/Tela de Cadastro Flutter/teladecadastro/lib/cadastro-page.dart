import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teladecadastro/cadastro-completo-page.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final nomeController = TextEditingController();
  final idadeController = TextEditingController();

  var nome = 'Nome Indefinido';
  var idade = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('\nCadastro de Pessoas'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          children: [


            
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: TextSelectionTheme(
                data: const TextSelectionThemeData(
                  selectionColor: Colors.blue,
                  selectionHandleColor: Colors.blue,
                ),
                child: TextField(
                  controller: nomeController,
                  cursorColor: Colors.black,
                  autocorrect: false,
                  enableSuggestions: false,
                  spellCheckConfiguration: const SpellCheckConfiguration.disabled(),
                  decoration: const InputDecoration(
                    labelText: 'Digite seu Nome',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: TextSelectionTheme(
                data: const TextSelectionThemeData(
                  selectionColor: Colors.blue,
                  selectionHandleColor: Colors.blue,
                ),
                child: TextField(
                  controller: idadeController,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Digite sua Idade',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 22, 0, 0),
              child: ElevatedButton(
                onPressed: () {
                  nome = nomeController.text;
                  idade = int.parse(idadeController.text);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CadastroCompletoPage(nome: nome, idade: idade),
                    ),
                  );
                },

                style: ButtonStyle(
                  minimumSize: WidgetStateProperty.all(const Size(110, 45)),

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
                      return Colors.blue;
                    }

                    return Colors.blue;
                  }),
                ),

                child: const Text('Completar Cadastro'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // "AppBar" = Barra do Aplicativo
  // "Children" = "Filhos" da Coluna
}