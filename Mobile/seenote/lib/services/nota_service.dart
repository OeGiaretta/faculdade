import '../data/notas.dart';

// Serviço para gerenciar as notas fiscais
class NotaService {
  List getAll() {
    return notas.values.toList();
  }

  Map<String, dynamic>? getById(String id) {
    return notas[id];
  }

  void create(String id, Map<String, dynamic> data) {
    notas[id] = data;
  }

  void update(String id, Map<String, dynamic> data) {
    final existing = notas[id];

    notas[id] = {
      "numero": id,
      "empresa": data['empresa'] ?? existing?['empresa'],
      "cnpj": data['cnpj'] ?? existing?['cnpj'],
      "valor": data['valor'] ?? existing?['valor'],
      "data": data['data'] ?? existing?['data'],
    };
  }

  void delete(String id) {
    notas.remove(id);
  }
}