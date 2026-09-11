import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProdutosPage extends StatefulWidget {
  const ProdutosPage({super.key});

  @override
  State<ProdutosPage> createState() => _ProdutosPageState();
}

class QuantidadeInputFormatter extends TextInputFormatter {
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

class ValorInputFormatter extends TextInputFormatter {
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

class _ProdutosPageState extends State<ProdutosPage> {
  var descricao = "Descrição Indefinida";
  var quantidade = 0;
  var valor = 0.0;

  final descricaoController = TextEditingController();
  final quantidadeController = TextEditingController();
  final valorController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '\nCadastro de Produtos',
          style: TextStyle(fontSize: 23),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),

      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // DESCRIÇÃO
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: TextSelectionTheme(
                    data: const TextSelectionThemeData(
                      selectionColor: Colors.blue,
                      selectionHandleColor: Colors.blue,
                    ),
                    child: TextFormField(
                      controller: descricaoController,
                      cursorColor: Colors.black,
                      autocorrect: false,
                      enableSuggestions: false,
                      spellCheckConfiguration:
                          const SpellCheckConfiguration.disabled(),
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe uma Descrição';
                        }

                        return null;
                      },
                    ),
                  ),
                ),

                // QUANTIDADE
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: TextSelectionTheme(
                    data: const TextSelectionThemeData(
                      selectionColor: Colors.blue,
                      selectionHandleColor: Colors.blue,
                    ),
                    child: TextFormField(
                      controller: quantidadeController,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.number,
                      inputFormatters: [QuantidadeInputFormatter()],
                      decoration: const InputDecoration(
                        labelText: 'Quantidade',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe uma Quantidade';
                        }

                        final quantidade = int.tryParse(
                          value.replaceAll('.', ''),
                        );

                        if (quantidade == null || quantidade <= 0) {
                          return 'A Quantidade deve ser maior que zero';
                        }

                        return null;
                      },
                    ),
                  ),
                ),

                // VALOR
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: TextSelectionTheme(
                    data: const TextSelectionThemeData(
                      selectionColor: Colors.blue,
                      selectionHandleColor: Colors.blue,
                    ),
                    child: TextFormField(
                      controller: valorController,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.number,
                      inputFormatters: [ValorInputFormatter()],
                      decoration: const InputDecoration(
                        labelText: 'Valor',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe um Valor';
                        }

                        return null;
                      },
                    ),
                  ),
                ),

                // BOTÃO SALVAR
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        descricao = descricaoController.text;

                        quantidade = int.parse(
                          quantidadeController.text.replaceAll('.', ''),
                        );

                        valor = double.parse(
                          valorController.text
                              .replaceAll('.', '')
                              .replaceAll(',', '.'),
                        );

                        print('\nDescrição: $descricao');
                        print('\nQuantidade: $quantidade');
                        print('\nValor: $valor');

                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Center(
                                child: Text('Dados Cadastrados'),
                              ),
                              content: Text(
                                'Descrição: $descricao\n'
                                'Quantidade: $quantidade\n'
                                'Valor: ${valor.toStringAsFixed(2)}',
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
                      }
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
                          return Colors.blue;
                        }

                        return Colors.blue;
                      }),
                    ),
                    child: const Text('Salvar', style: TextStyle(fontSize: 15)),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
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
                    child: const Text('Voltar', style: TextStyle(fontSize: 15)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}