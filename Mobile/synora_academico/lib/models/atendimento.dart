
class Atendimento {
  final int? id;
  final int agendamentoId;
  final DateTime realizadoEm;
  final String? observacaoAdministrativa;

  const Atendimento({
    this.id,
    required this.agendamentoId,
    required this.realizadoEm,
    this.observacaoAdministrativa,
  });

  Map<String, dynamic> toMap() {
    return {
      'agendamento_id': agendamentoId,
      'realizado_em': realizadoEm.toIso8601String(),
      'observacao_administrativa':
          observacaoAdministrativa,
    };
  }

  factory Atendimento.fromMap(Map<String, dynamic> map) {
    return Atendimento(
      id: map['id'] as int,
      agendamentoId: map['agendamento_id'] as int,
      realizadoEm: DateTime.parse(
        map['realizado_em'] as String,
      ),
      observacaoAdministrativa:
          map['observacao_administrativa'] as String?,
    );
  }

  Atendimento copyWith({
    int? id,
    int? agendamentoId,
    DateTime? realizadoEm,
    String? observacaoAdministrativa,
  }) {
    return Atendimento(
      id: id ?? this.id,
      agendamentoId: agendamentoId ?? this.agendamentoId,
      realizadoEm: realizadoEm ?? this.realizadoEm,
      observacaoAdministrativa:
          observacaoAdministrativa ??
          this.observacaoAdministrativa,
    );
  }
}
