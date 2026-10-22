
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../models/agendamento.dart';
import '../../models/atendimento.dart';
import '../../models/paciente.dart';
import '../../models/pagamento.dart';
import '../../repositories/agendamento_repository.dart';
import '../../repositories/atendimento_repository.dart';
import '../../repositories/paciente_repository.dart';
import '../../repositories/pagamento_repository.dart';
import '../../repositories/psicologo_repository.dart';

class PagamentoFormPage extends StatefulWidget {
  final Pagamento? pagamento;

  const PagamentoFormPage({
    super.key,
    this.pagamento,
  });

  @override
  State<PagamentoFormPage> createState() =>
      _PagamentoFormPageState();
}

class _PagamentoFormPageState extends State<PagamentoFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _valorController = TextEditingController();

  final _pagamentoRepository = PagamentoRepository();
  final _atendimentoRepository = AtendimentoRepository();
  final _agendamentoRepository = AgendamentoRepository();
  final _pacienteRepository = PacienteRepository();
  final _psicologoRepository = PsicologoRepository();

  List<Atendimento> _atendimentos = [];
  Map<int, Agendamento> _agendamentos = {};
  Map<int, Paciente> _pacientes = {};

  int? _atendimentoId;
  String _status = 'pendente';
  String _formaPagamento = 'pix';
  DateTime? _dataPagamento;

  bool _carregando = true;
  bool _salvando = false;
  String? _erro;

  bool get _editando => widget.pagamento != null;

  @override
  void initState() {
    super.initState();

    final pagamento = widget.pagamento;

    if (pagamento != null) {
      _atendimentoId = pagamento.atendimentoId;
      _valorController.text =
          pagamento.valor.toStringAsFixed(2).replaceAll('.', ',');
      _status = pagamento.status;
      _formaPagamento = pagamento.formaPagamento ?? 'pix';
      _dataPagamento = pagamento.dataPagamento;
    }

    _carregarDados();
  }

  @override
  void dispose() {
    _valorController.dispose();
    super.dispose();
  }

  Future<void> _carregarDados() async {
    try {
      final psicologo =
          await _psicologoRepository.buscarPrimeiro();

      if (psicologo?.id == null) {
        throw StateError('Psicólogo não encontrado.');
      }

      final pacientes =
          await _pacienteRepository.listar(psicologo!.id!);

      final agendamentos =
          await _agendamentoRepository.listar();

      final atendimentos =
          await _atendimentoRepository.listar();

      final pacientesMap = {
        for (final paciente in pacientes)
          if (paciente.id != null) paciente.id!: paciente,
      };

      final agendamentosMap = {
        for (final agendamento in agendamentos)
          if (agendamento.id != null &&
              pacientesMap.containsKey(agendamento.pacienteId))
            agendamento.id!: agendamento,
      };

      final atendimentosValidos = atendimentos.where((atendimento) {
        return agendamentosMap.containsKey(
          atendimento.agendamentoId,
        );
      }).toList();

      if (!mounted) return;

      setState(() {
        _pacientes = pacientesMap;
        _agendamentos = agendamentosMap;
        _atendimentos = atendimentosValidos;
        _carregando = false;
      });
    } catch (erro) {
      if (!mounted) return;

      setState(() {
        _erro = erro.toString();
        _carregando = false;
      });
    }
  }

  String _descricaoAtendimento(Atendimento atendimento) {
    final agendamento =
        _agendamentos[atendimento.agendamentoId];

    if (agendamento == null) {
      return 'Atendimento #${atendimento.id}';
    }

    final paciente = _pacientes[agendamento.pacienteId];

    final nome = paciente?.nome ?? 'Paciente desconhecido';

    final data = DateFormat('dd/MM/yyyy').format(
      atendimento.realizadoEm,
    );

    return '$nome - $data';
  }

  Future<void> _selecionarDataPagamento() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataPagamento ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (data == null || !mounted) return;

    setState(() {
      _dataPagamento = data;
    });
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate() || _salvando) {
      return;
    }

    final valor = double.tryParse(
      _valorController.text.trim().replaceAll(',', '.'),
    );

    if (valor == null || !valor.isFinite || valor < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe um valor válido.'),
        ),
      );
      return;
    }

    if (_atendimentoId == null) return;

    setState(() => _salvando = true);

    try {
      final pagamento = Pagamento(
        id: widget.pagamento?.id,
        atendimentoId: _atendimentoId!,
        valor: valor,
        status: _status,
        formaPagamento: _formaPagamento,
        dataPagamento: _status == 'pago'
            ? (_dataPagamento ?? DateTime.now())
            : null,
      );

      if (_editando) {
        final alterados =
            await _pagamentoRepository.atualizar(pagamento);

        if (alterados == 0) {
          throw StateError('Pagamento não encontrado.');
        }
      } else {
        await _pagamentoRepository.inserir(pagamento);
      }

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (erro) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar pagamento: $erro'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _salvando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const corPrincipal = Color(0xFF587C78);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _editando ? 'Editar pagamento' : 'Novo pagamento',
        ),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _erro != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(_erro!),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                      children: [
                        const Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 64,
                          color: corPrincipal,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Dados do pagamento',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        DropdownButtonFormField<int>(
                          initialValue: _atendimentoId,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Atendimento *',
                            border: OutlineInputBorder(),
                            prefixIcon:
                                Icon(Icons.assignment_outlined),
                          ),
                          items: _atendimentos.map((atendimento) {
                            return DropdownMenuItem<int>(
                              value: atendimento.id,
                              child: Text(
                                _descricaoAtendimento(atendimento),
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: _editando
                              ? null
                              : (valor) {
                                  setState(() {
                                    _atendimentoId = valor;
                                  });
                                },
                          validator: (valor) {
                            return valor == null
                                ? 'Selecione um atendimento'
                                : null;
                          },
                        ),

                        if (_atendimentos.isEmpty) ...[
                          const SizedBox(height: 12),
                          const Text(
                            'Nenhum atendimento disponível. '
                            'Registre um atendimento primeiro.',
                          ),
                        ],

                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _valorController,
                          keyboardType:
                              const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9,.]'),
                            ),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Valor (R\$) *',
                            hintText: 'Ex.: 150,00',
                            prefixIcon:
                                Icon(Icons.attach_money),
                            border: OutlineInputBorder(),
                          ),
                          validator: (texto) {
                            final valor = double.tryParse(
                              (texto ?? '')
                                  .trim()
                                  .replaceAll(',', '.'),
                            );

                            if (valor == null ||
                                !valor.isFinite ||
                                valor < 0) {
                              return 'Informe um valor válido';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        DropdownButtonFormField<String>(
                          initialValue: _formaPagamento,
                          decoration: const InputDecoration(
                            labelText: 'Forma de pagamento',
                            border: OutlineInputBorder(),
                            prefixIcon:
                                Icon(Icons.credit_card_outlined),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'pix',
                              child: Text('PIX'),
                            ),
                            DropdownMenuItem(
                              value: 'dinheiro',
                              child: Text('Dinheiro'),
                            ),
                            DropdownMenuItem(
                              value: 'cartao',
                              child: Text('Cartão'),
                            ),
                            DropdownMenuItem(
                              value: 'transferencia',
                              child: Text('Transferência'),
                            ),
                          ],
                          onChanged: (valor) {
                            if (valor != null) {
                              setState(() {
                                _formaPagamento = valor;
                              });
                            }
                          },
                        ),

                        const SizedBox(height: 20),

                        DropdownButtonFormField<String>(
                          initialValue: _status,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                            prefixIcon:
                                Icon(Icons.info_outline),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'pendente',
                              child: Text('Pendente'),
                            ),
                            DropdownMenuItem(
                              value: 'pago',
                              child: Text('Pago'),
                            ),
                            DropdownMenuItem(
                              value: 'cancelado',
                              child: Text('Cancelado'),
                            ),
                          ],
                          onChanged: (valor) {
                            if (valor != null) {
                              setState(() {
                                _status = valor;

                                if (valor == 'pago') {
                                  _dataPagamento ??= DateTime.now();
                                } else {
                                  _dataPagamento = null;
                                }
                              });
                            }
                          },
                        ),

                        if (_status == 'pago') ...[
                          const SizedBox(height: 20),
                          OutlinedButton.icon(
                            onPressed: _selecionarDataPagamento,
                            icon: const Icon(
                              Icons.calendar_today_outlined,
                            ),
                            label: Text(
                              'Data do pagamento: '
                              '${DateFormat('dd/MM/yyyy').format(_dataPagamento ?? DateTime.now())}',
                            ),
                          ),
                        ],

                        const SizedBox(height: 28),

                        FilledButton.icon(
                          onPressed: _salvando ||
                                  _atendimentos.isEmpty
                              ? null
                              : _salvar,
                          style: FilledButton.styleFrom(
                            backgroundColor: corPrincipal,
                            padding: const EdgeInsets.all(16),
                          ),
                          icon: const Icon(Icons.save_outlined),
                          label: Text(
                            _salvando
                                ? 'Salvando...'
                                : 'Salvar pagamento',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
