
class Psicologo {
  final int? id;
  final String nome;
  final String? crp;
  final String? email;
  final String? telefone;

  const Psicologo({
    this.id,
    required this.nome,
    this.crp,
    this.email,
    this.telefone,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'crp': crp,
      'email': email,
      'telefone': telefone,
    };
  }

  factory Psicologo.fromMap(Map<String, dynamic> map) {
    return Psicologo(
      id: map['id'] as int,
      nome: map['nome'] as String,
      crp: map['crp'] as String?,
      email: map['email'] as String?,
      telefone: map['telefone'] as String?,
    );
  }
}
