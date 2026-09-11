import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  final nomeController = TextEditingController();
  final enderecoController = TextEditingController();
  final cidadeController = TextEditingController();
  final ufController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var nome = "Nome Indefinido";
  var endereco = "Endereço Indefinido";
  var cidade = "Cidade Indefinida";
  var uf = "UF Indefinido";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '\nCadastro de Clientes',
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: TextSelectionTheme(
                    data: const TextSelectionThemeData(
                      selectionColor: Colors.blue,
                      selectionHandleColor: Colors.blue,
                    ),
                    child: TextFormField(
                      controller: nomeController,
                      cursorColor: Colors.black,
                      autocorrect: false,
                      enableSuggestions: false,
                      spellCheckConfiguration:
                          const SpellCheckConfiguration.disabled(),
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
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe seu Nome';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 19, 0, 0),
                  child: TextSelectionTheme(
                    data: const TextSelectionThemeData(
                      selectionColor: Colors.blue,
                      selectionHandleColor: Colors.blue,
                    ),
                    child: TextFormField(
                      controller: enderecoController,
                      cursorColor: Colors.black,
                      autocorrect: false,
                      enableSuggestions: false,
                      spellCheckConfiguration:
                          const SpellCheckConfiguration.disabled(),
                      decoration: const InputDecoration(
                        labelText: 'Digite seu Endereço',
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
                          return 'Informe seu Endereço';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 19, 0, 0),
                  child: TextSelectionTheme(
                    data: const TextSelectionThemeData(
                      selectionColor: Colors.blue,
                      selectionHandleColor: Colors.blue,
                    ),
                    child: TextFormField(
                      controller: cidadeController,
                      cursorColor: Colors.black,
                      autocorrect: false,
                      enableSuggestions: false,
                      spellCheckConfiguration:
                          const SpellCheckConfiguration.disabled(),
                      decoration: const InputDecoration(
                        labelText: 'Digite sua Cidade',
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
                          return 'Informe uma Cidade';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 19, 0, 0),
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'UF',
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
                      if (value == null || value.isEmpty) {
                        return 'Selecione uma UF';
                      }
                      return null;
                    },
                    menuMaxHeight: 250,
                    itemHeight: 48,
                    items: const [
                      DropdownMenuItem(value: 'AC', child: Text('AC')),
                      DropdownMenuItem(value: 'AL', child: Text('AL')),
                      DropdownMenuItem(value: 'AP', child: Text('AP')),
                      DropdownMenuItem(value: 'AM', child: Text('AM')),
                      DropdownMenuItem(value: 'BA', child: Text('BA')),
                      DropdownMenuItem(value: 'CE', child: Text('CE')),
                      DropdownMenuItem(value: 'DF', child: Text('DF')),
                      DropdownMenuItem(value: 'ES', child: Text('ES')),
                      DropdownMenuItem(value: 'GO', child: Text('GO')),
                      DropdownMenuItem(value: 'MA', child: Text('MA')),
                      DropdownMenuItem(value: 'MT', child: Text('MT')),
                      DropdownMenuItem(value: 'MS', child: Text('MS')),
                      DropdownMenuItem(value: 'MG', child: Text('MG')),
                      DropdownMenuItem(value: 'PA', child: Text('PA')),
                      DropdownMenuItem(value: 'PB', child: Text('PB')),
                      DropdownMenuItem(value: 'PR', child: Text('PR')),
                      DropdownMenuItem(value: 'PE', child: Text('PE')),
                      DropdownMenuItem(value: 'PI', child: Text('PI')),
                      DropdownMenuItem(value: 'RJ', child: Text('RJ')),
                      DropdownMenuItem(value: 'RN', child: Text('RN')),
                      DropdownMenuItem(value: 'RS', child: Text('RS')),
                      DropdownMenuItem(value: 'RO', child: Text('RO')),
                      DropdownMenuItem(value: 'RR', child: Text('RR')),
                      DropdownMenuItem(value: 'SC', child: Text('SC')),
                      DropdownMenuItem(value: 'SP', child: Text('SP')),
                      DropdownMenuItem(value: 'SE', child: Text('SE')),
                      DropdownMenuItem(value: 'TO', child: Text('TO')),
                    ],
                    onChanged: (valor) {
                      setState(() {
                        uf = valor ?? "UF Indefinido";
                      });
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 22, 0, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        nome = nomeController.text;
                        endereco = enderecoController.text;
                        cidade = cidadeController.text;

                        print('\nNome: $nome');
                        print('\nEndereço: $endereco');
                        print('\nCidade: $cidade');
                        print('\nUF: $uf');

                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Center(
                                child: Text('Dados Cadastrados'),
                              ),
                              content: Text(
                                'Nome: $nome\n'
                                'Endereço: $endereco\n'
                                'Cidade: $cidade\n'
                                'UF: $uf',
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