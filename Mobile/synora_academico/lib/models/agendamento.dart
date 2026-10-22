
class Agendamento {
  final int? id;
  final int pacienteId;
  final DateTime dataHoraInicio;
  final DateTime dataHoraFim;
  final String modalidade;
  final String status;

  const Agendamento({
    this.id,
    required this.pacienteId,
    required this.dataHoraInicio,
    required this.dataHoraFim,
    this.modalidade = 'presencial',
    this.status = 'agendado',
  });

  Map<String, dynamic> toMap() {
    return {
      'paciente_id': pacienteId,
      'data_hora_inicio': dataHoraInicio.toIso8601String(),
      'data_hora_fim': dataHoraFim.toIso8601String(),
      'modalidade': modalidade,
      'status': status,
    };
  }

  factory Agendamento.fromMap(Map<String, dynamic> map) {
    return Agendamento(
      id: map['id'] as int,
      pacienteId: map['paciente_id'] as int,
      dataHoraInicio: DateTime.parse(
        map['data_hora_inicio'] as String,
      ),
      dataHoraFim: DateTime.parse(
        map['data_hora_fim'] as String,
      ),
      modalidade: map['modalidade'] as String,
      status: map['status'] as String,
    );
  }

  Agendamento copyWith({
    int? id,
    int? pacienteId,
    DateTime? dataHoraInicio,
    DateTime? dataHoraFim,
    String? modalidade,
    String? status,
  }) {
    return Agendamento(
      id: id ?? this.id,
      pacienteId: pacienteId ?? this.pacienteId,
      dataHoraInicio: dataHoraInicio ?? this.dataHoraInicio,
      dataHoraFim: dataHoraFim ?? this.dataHoraFim,
      modalidade: modalidade ?? this.modalidade,
      status: status ?? this.status,
    );
  }
}
