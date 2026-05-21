import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

import '../lib/data/notas.dart';

void main() async {
    final router = Router();

    // Página inicial
    router.get('/', (Request request) {
        return Response.ok('SeeNote API Online');
    });

    // Cria rota para listar todas as notas fiscais
    router.get('/notas', (Request request) {
        return Response.ok(
            jsonEncode(notas.values.toList()),
            headers: {'Content-Type': 'application/json'},
        );
    });

    // Cria rota para criar uma nova nota fiscal
    router.post('/nota', (Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body);

    if (data['numero'] == null ||
        data['empresa'] == null ||
        data['valor'] == null) {
        return Response(
        400,
        body: jsonEncode({
            "erro": "Campos obrigatórios: numero, empresa, valor"
        }),
        headers: {'Content-Type': 'application/json'},
        );
    }

    final numero = data['numero'];

    notas[numero] = data;

    return Response.ok(
        jsonEncode({
            "mensagem": "Nota criada com sucesso",
            "nota": data
        }),
        headers: {'Content-Type': 'application/json'},
    );
    });

    // Consulta de nota fiscal
    router.get('/nota/<id>', (Request request, String id) {
        final nota = notas[id];

        if (nota == null) {
            return Response.notFound(
                jsonEncode({"erro": "Nota não encontrada"}),
                headers: {'Content-Type': 'application/json'},
            );
        }

        return Response.ok(
            jsonEncode(nota),
            headers: {'Content-Type': 'application/json'},
        );
    });

    final server = await io.serve(
        router.call,
        'localhost',
        8080,
    );

    print('Servidor rodando em http://${server.address.host}:${server.port}');
}