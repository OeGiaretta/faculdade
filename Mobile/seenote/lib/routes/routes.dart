import 'package:shelf_router/shelf_router.dart';
import '../controllers/nota_controller.dart';

// Função para criar as rotas da API.
Router createRoutes() {
  final router = Router();
  final controller = NotaController();

  router.get('/', (req) => Response.ok('SeeNote API Online'));

  router.get('/notas', controller.getAll);
  router.get('/nota/<id>', controller.getById);

  router.post('/nota', controller.create);
  router.put('/nota/<id>', controller.update);
  router.delete('/nota/<id>', controller.delete);

  return router;
}