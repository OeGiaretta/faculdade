
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> buscarCep(String cep) async {
  final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dados = jsonDecode(response.body);

      if (dados.containsKey('erro')) {
        print('CEP não encontrado.');
        return;
      }

      print('\n===== DADOS DO CEP =====');
      print('CEP: ${dados['cep']}');
      print('Logradouro: ${dados['logradouro']}');
      print('Complemento: ${dados['complemento']}');
      print('Bairro: ${dados['bairro']}');
      print('Cidade: ${dados['localidade']}');
      print('Estado: ${dados['uf']}');
      print('DDD: ${dados['ddd']}');
    } else {
      print('Erro na requisição.');
    }
  } catch (e) {
    print('Erro: $e');
  }
}

void main() async {
  print('Digite um CEP:');

  String? cep = stdin.readLineSync();

  if (cep == null || cep.isEmpty) {
    print('CEP inválido.');
    return;
  }

  await buscarCep(cep);
}