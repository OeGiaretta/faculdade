import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SalarioInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String numeros = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (numeros.isEmpty) {
      return const TextEditingValue();
    }

    String formatado = '';

    for (int i = 0; i < numeros.length; i++) {
      int posicao = numeros.length - i;

      formatado = numeros[posicao - 1] + formatado;

      if (i % 3 == 2 && posicao > 1) {
        formatado = '.$formatado';
      }
    }

    return TextEditingValue(
      text: formatado,
      selection: TextSelection.collapsed(offset: formatado.length),
    );
  }
}

class CadastroCompletoPage extends StatefulWidget {
  final String nome;
  final int idade;

  const CadastroCompletoPage({
    super.key,
    required this.nome,
    required this.idade,
  });

  @override
  State<CadastroCompletoPage> createState() => _CadastroCompletoPageState();
}

class _CadastroCompletoPageState extends State<CadastroCompletoPage> {
  final sexoController = TextEditingController();
  final salarioController = TextEditingController();

  var sexo = 'Sexo Indefinido';
  var salario = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('\nCompletar Cadastro'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Sexo',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
              ),

              items: const [
                DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
                DropdownMenuItem(value: 'Feminino', child: Text('Feminino')),
              ],

              onChanged: (valor) {
                setState(() {
                  sexo = valor!;
                });
              },
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: TextSelectionTheme(
                data: const TextSelectionThemeData(
                  selectionColor: Colors.blue,
                  selectionHandleColor: Colors.blue,
                ),

                child: TextField(
                  controller: salarioController,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.number,

                  inputFormatters: [SalarioInputFormatter()],

                  decoration: const InputDecoration(
                    labelText: 'Digite seu Salário',
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
                  setState(() {
                    salario = int.parse(
                      salarioController.text.replaceAll('.', ''),
                    );
                  });

                  print('\nNome: ${widget.nome}');
                  print('\nIdade: ${widget.idade}');
                  print('\nSexo: $sexo');
                  print('\nSalário: $salario');

                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Center(child: Text('Cadastro Completo')),

                        content: Text(
                          'Nome: ${widget.nome}\n'
                          'Idade: ${widget.idade} anos\n'
                          'Sexo: $sexo\n'
                          'Salário: R\$ ${salarioController.text}',
                        ),

                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                            ),
                            child: const Text('Fechar'),
                          ),
                        ],
                      );
                    },
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

                child: const Text('Salvar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}