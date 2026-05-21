import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/nota_service.dart';

// Controlador para gerenciar as rotas relacionadas às notas fiscais
class NotaController {
  final service = NotaService();

  Response getAll(Request req) {
    return Response.ok(
      jsonEncode(service.getAll()),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Response getById(Request req, String id) {
    final nota = service.getById(id);

    if (nota == null) {
      return Response.notFound(
        jsonEncode({"erro": "Nota não encontrada"}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    return Response.ok(jsonEncode(nota));
  }

  Future<Response> create(Request req) async {
    final body = await req.readAsString();
    final data = jsonDecode(body);

    final id = data['numero'];

    service.create(id, data);

    return Response(
      201,
      body: jsonEncode({"mensagem": "Nota criada"}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<Response> update(Request req, String id) async {
    final body = await req.readAsString();
    final data = jsonDecode(body);

    final existing = service.getById(id);

    if (existing == null) {
      return Response.notFound(
        jsonEncode({"erro": "Nota não encontrada"}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    service.update(id, data);

    return Response.ok(
      jsonEncode({"mensagem": "Nota atualizada"}),
    );
  }

  Response delete(Request req, String id) {
    final existing = service.getById(id);

    if (existing == null) {
      return Response.notFound(
        jsonEncode({"erro": "Nota não encontrada"}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    service.delete(id);

    return Response.ok(
      jsonEncode({"mensagem": "Nota removida"}),
      headers: {'Content-Type': 'application/json'},
    );
  }
}