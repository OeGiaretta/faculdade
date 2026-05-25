import 'dart:convert';

import 'package:shelf/shelf.dart';

// Middleware personalizado da aplicação
Middleware customMiddleware() {
  return (Handler innerHandler) {

    return (Request request) async {

      // LOG DA REQUISIÇÃO
      print(
        '[${request.method}] ${request.requestedUri}'
      );

      try {

        // Continua fluxo da API
        final response = await innerHandler(request);

        // Adiciona header padrão JSON
        return response.change(
          headers: {
            ...response.headers,
            'Content-Type': 'application/json',
          },
        );

      } catch (e) {

        // Tratamento global de erro
        return Response.internalServerError(
          body: jsonEncode({
            "success": false,
            "message": "Erro interno no servidor",
            "error": e.toString(),
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        );
      }
    };
  };
}