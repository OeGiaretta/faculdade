import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

import 'package:seenote/middleware/middleware.dart';

import '../lib/routes/routes.dart';

void main() async {

  // Cria rotas
  final router = createRoutes();

  // Cria pipeline com middleware
  final handler = Pipeline()
      .addMiddleware(customMiddleware())
      .addHandler(router);

  // Inicializa servidor
  final server = await io.serve(
    handler,
    'localhost',
    8080,
  );

  print(
    'Servidor rodando em http://${server.address.host}:${server.port}',
  );
}