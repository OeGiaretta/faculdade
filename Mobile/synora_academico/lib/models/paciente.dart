
class Paciente {
  final int? id;
  final int psicologoId;
  final String nome;
  final String? telefone;
  final String? email;
  final String? dataNascimento;
  final bool ativo;
  final String? criadoEm;

  const Paciente({
    this.id,
    required this.psicologoId,
    required this.nome,
    this.telefone,
    this.email,
    this.dataNascimento,
    this.ativo = true,
    this.criadoEm,
  });

  Map<String, dynamic> toMap() {
    return {
      'psicologo_id': psicologoId,
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'data_nascimento': dataNascimento,
      'ativo': ativo ? 1 : 0,
    };
  }

  factory Paciente.fromMap(Map<String, dynamic> map) {
    return Paciente(
      id: map['id'] as int,
      psicologoId: map['psicologo_id'] as int,
      nome: map['nome'] as String,
      telefone: map['telefone'] as String?,
      email: map['email'] as String?,
      dataNascimento: map['data_nascimento'] as String?,
      ativo: (map['ativo'] as int) == 1,
      criadoEm: map['criado_em'] as String?,
    );
  }
}
