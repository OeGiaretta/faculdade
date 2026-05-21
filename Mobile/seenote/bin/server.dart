import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

import 'package:seenote/data/notas.dart';

void main() async {
    final router = Router();

    // Página inicial
    router.get('/', (Request request) {
        return Response.ok('SeeNote API Online');
    });

    // Consulta de nota fiscal
    router.get('/notas', (Request request) {
        return Response.ok(
            jsonEncode(notas.values.toList()),
            headers: {'Content-Type': 'application/json'},
        );
    });

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

        if (notas[numero] != null) {
                return Response(
                    409,
                    body: jsonEncode({"erro": "Nota já existe"}),
                    headers: {'Content-Type': 'application/json'},
            );
        }

        notas[numero] = data;

        return Response(
            201,
            body: jsonEncode({
                "mensagem": "Nota incluída com sucesso",
                "nota": data
            }),
            headers: {'Content-Type': 'application/json'},
        );
    });

    // Edita uma nota fiscal existente
    router.put('/nota/<id>', (Request request, String id) async {
        final body = await request.readAsString();
        final data = jsonDecode(body);

        final notaExistente = notas[id];

        if (notaExistente == null) {
            return Response.notFound(
                jsonEncode({"erro": "Nota não encontrada"}),
                headers: {'Content-Type': 'application/json'},
            );
        }

        notas[id] = {
            "numero": id,
            "empresa": data['empresa'] ?? notaExistente['empresa'],
            "cnpj": data['cnpj'] ?? notaExistente['cnpj'],
            "valor": data['valor'] ?? notaExistente['valor'],
            "data": data['data'] ?? notaExistente['data'],
        };

        return Response.ok(
            jsonEncode({
                "mensagem": "Nota atualizada com sucesso",
                "nota": notas[id]
            }),
            headers: {'Content-Type': 'application/json'},
        );
    });

    // Deleta uma nota fiscal
    router.delete('/nota/<id>', (Request request, String id) {
            final notaExistente = notas[id];

            if (notaExistente == null) {
            return Response.notFound(
                jsonEncode({"erro": "Nota não encontrada"}),
                headers: {'Content-Type': 'application/json'},
            );
        }

        notas.remove(id);

        return Response(
            200,
            body: jsonEncode({"mensagem": "Nota removida com sucesso"}),
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