
class Pagamento {
  final int? id;
  final int atendimentoId;
  final double valor;
  final DateTime? dataPagamento;
  final String? formaPagamento;
  final String status;

  const Pagamento({
    this.id,
    required this.atendimentoId,
    required this.valor,
    this.dataPagamento,
    this.formaPagamento,
    this.status = 'pendente',
  });

  Map<String, dynamic> toMap() {
    return {
      'atendimento_id': atendimentoId,
      'valor': valor,
      'data_pagamento': dataPagamento?.toIso8601String(),
      'forma_pagamento': formaPagamento,
      'status': status,
    };
  }

  factory Pagamento.fromMap(Map<String, dynamic> map) {
    return Pagamento(
      id: map['id'] as int,
      atendimentoId: map['atendimento_id'] as int,
      valor: (map['valor'] as num).toDouble(),
      dataPagamento: map['data_pagamento'] == null
          ? null
          : DateTime.parse(map['data_pagamento'] as String),
      formaPagamento: map['forma_pagamento'] as String?,
      status: map['status'] as String,
    );
  }

  Pagamento copyWith({
    int? id,
    int? atendimentoId,
    double? valor,
    DateTime? dataPagamento,
    String? formaPagamento,
    String? status,
  }) {
    return Pagamento(
      id: id ?? this.id,
      atendimentoId: atendimentoId ?? this.atendimentoId,
      valor: valor ?? this.valor,
      dataPagamento: dataPagamento ?? this.dataPagamento,
      formaPagamento: formaPagamento ?? this.formaPagamento,
      status: status ?? this.status,
    );
  }
}
