import 'package:shelf/shelf_io.dart' as io;
import '../lib/routes/routes.dart';

void main() async {
  final router = createRoutes();

  final server = await io.serve(router, 'localhost', 8080);

  print('Servidor rodando em http://${server.address.host}:${server.port}');
}