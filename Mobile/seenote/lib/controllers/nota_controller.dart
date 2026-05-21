import 'dart:convert';
import 'package:shelf/shelf.dart';

import '../services/nota_service.dart';
import '../models/api_response.dart';
import '../database/database.dart';

class NotaController {
  final db = DatabaseService().db;
  
  late final NotaService service = NotaService(db);

  // Lista todas as notas fiscais
  Response getAll(Request req) {
    final response = ApiResponse(
      success: true,
      message: "Notas listadas com sucesso",
      data: service.getAll(),
    );

    return Response.ok(
      jsonEncode(response.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  }

  // Busca uma nota fiscal pelo número
  Response getById(Request req, String id) {
    final nota = service.getById(id);

    if (nota == null) {
      final response = ApiResponse(
        success: false,
        message: "Nota não encontrada",
        data: null,
      );

      return Response.notFound(
        jsonEncode(response.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final response = ApiResponse(
      success: true,
      message: "Nota encontrada",
      data: nota,
    );

    return Response.ok(
      jsonEncode(response.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  }

  // Cria uma nova nota fiscal
  Future<Response> create(Request req) async {
    final body = await req.readAsString();
    final data = jsonDecode(body);

    if (data['numero'] == null ||
        data['empresa'] == null ||
        data['valor'] == null) {

      final response = ApiResponse(
        success: false,
        message: "Campos obrigatórios: numero, empresa e valor",
        data: null,
      );

      return Response(
        400,
        body: jsonEncode(response.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    }

    service.create(data);

    final response = ApiResponse(
      success: true,
      message: "Nota criada com sucesso",
      data: data,
    );

    return Response(
      201,
      body: jsonEncode(response.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  }
  // Atualiza uma nota fiscal
  Future<Response> update(Request req, String id) async {
    final body = await req.readAsString();
    final data = jsonDecode(body);

    final existing = service.getById(id);

    if (existing == null) {
      final response = ApiResponse(
        success: false,
        message: "Nota não encontrada",
        data: null,
      );

      return Response.notFound(
        jsonEncode(response.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    }

    service.update(id, data);

    final response = ApiResponse(
      success: true,
      message: "Nota atualizada com sucesso",
      data: data,
    );

    return Response.ok(
      jsonEncode(response.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  }

  // Remove uma nota fiscal
  Response delete(Request req, String id) {
    final existing = service.getById(id);

    if (existing == null) {
      final response = ApiResponse(
        success: false,
        message: "Nota não encontrada",
        data: null,
      );

      return Response.notFound(
        jsonEncode(response.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    }

    service.delete(id);

    final response = ApiResponse(
      success: true,
      message: "Nota removida com sucesso",
      data: null,
    );

    return Response.ok(
      jsonEncode(response.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  }
}