
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/agendamento.dart';
import '../../models/atendimento.dart';
import '../../models/paciente.dart';
import '../../repositories/agendamento_repository.dart';
import '../../repositories/atendimento_repository.dart';
import '../../repositories/paciente_repository.dart';
import '../../repositories/psicologo_repository.dart';

class AtendimentoFormPage extends StatefulWidget {
  final Atendimento? atendimento;

  const AtendimentoFormPage({
    super.key,
    this.atendimento,
  });

  @override
  State<AtendimentoFormPage> createState() =>
      _AtendimentoFormPageState();
}

class _AtendimentoFormPageState
    extends State<AtendimentoFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _atendimentoRepository = AtendimentoRepository();
  final _agendamentoRepository = AgendamentoRepository();
  final _pacienteRepository = PacienteRepository();
  final _psicologoRepository = PsicologoRepository();

  final _observacaoController = TextEditingController();

  List<Agendamento> _agendamentos = [];
  Map<int, Paciente> _pacientes = {};

  int? _agendamentoId;
  DateTime _realizadoEm = DateTime.now();

  bool _carregando = true;
  bool _salvando = false;
  String? _erro;

  bool get _editando => widget.atendimento != null;

  @override
  void initState() {
    super.initState();

    if (_editando) {
      _agendamentoId = widget.atendimento!.agendamentoId;
      _realizadoEm = widget.atendimento!.realizadoEm;
      _observacaoController.text =
          widget.atendimento!.observacaoAdministrativa ?? '';
    }

    _carregarDados();
  }

  @override
  void dispose() {
    _observacaoController.dispose();
    super.dispose();
  }

  Future<void> _carregarDados() async {
    try {
      final psicologo =
          await _psicologoRepository.buscarPrimeiro();

      if (psicologo?.id == null) {
        throw StateError('Psicólogo não encontrado.');
      }

      final pacientes = await _pacienteRepository.listar(
        psicologo!.id!,
      );

      final agendamentos =
          await _agendamentoRepository.listar();

      final atendimentos =
          await _atendimentoRepository.listar();

      final idsUtilizados = atendimentos
          .map((atendimento) => atendimento.agendamentoId)
          .toSet();

      final pacientesMap = {
        for (final paciente in pacientes)
          if (paciente.id != null) paciente.id!: paciente,
      };

      final disponiveis = agendamentos.where((agendamento) {
        final pertenceAoPsicologo =
            pacientesMap.containsKey(agendamento.pacienteId);

        if (!pertenceAoPsicologo) return false;

        if (_editando) {
          return agendamento.id == _agendamentoId;
        }

        final statusPermitido =
            agendamento.status == 'agendado' ||
            agendamento.status == 'concluido';

        return statusPermitido &&
            !idsUtilizados.contains(agendamento.id);
      }).toList();

      if (!mounted) return;

      setState(() {
        _pacientes = pacientesMap;
        _agendamentos = disponiveis;
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

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _realizadoEm,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (data == null || !mounted) return;

    setState(() {
      _realizadoEm = DateTime(
        data.year,
        data.month,
        data.day,
        _realizadoEm.hour,
        _realizadoEm.minute,
      );
    });
  }

  Future<void> _selecionarHorario() async {
    final horario = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_realizadoEm),
    );

    if (horario == null || !mounted) return;

    setState(() {
      _realizadoEm = DateTime(
        _realizadoEm.year,
        _realizadoEm.month,
        _realizadoEm.day,
        horario.hour,
        horario.minute,
      );
    });
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate() || _salvando) {
      return;
    }

    if (_agendamentoId == null) return;

    setState(() => _salvando = true);

    try {
      final atendimento = Atendimento(
        id: widget.atendimento?.id,
        agendamentoId: _agendamentoId!,
        realizadoEm: _realizadoEm,
        observacaoAdministrativa:
            _observacaoController.text.trim().isEmpty
                ? null
                : _observacaoController.text.trim(),
      );

      if (_editando) {
        final alterados =
            await _atendimentoRepository.atualizar(atendimento);

        if (alterados == 0) {
          throw StateError('Atendimento não encontrado.');
        }
      } else {
        await _atendimentoRepository.inserir(atendimento);
      }

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (erro) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar atendimento: $erro'),
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
          _editando
              ? 'Editar atendimento'
              : 'Registrar atendimento',
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
                          Icons.assignment_turned_in_outlined,
                          size: 64,
                          color: corPrincipal,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _editando
                              ? 'Editar atendimento'
                              : 'Registrar consulta realizada',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Registre apenas informações '
                          'administrativas da consulta.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),

                        DropdownButtonFormField<int>(
                          initialValue: _agendamentoId,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Consulta *',
                            border: OutlineInputBorder(),
                            prefixIcon:
                                Icon(Icons.event_outlined),
                          ),
                          items: _agendamentos.map((agendamento) {
                            final nome = _pacientes[
                                        agendamento.pacienteId]
                                    ?.nome ??
                                'Paciente desconhecido';

                            final data = DateFormat(
                              'dd/MM/yyyy HH:mm',
                            ).format(
                              agendamento.dataHoraInicio,
                            );

                            return DropdownMenuItem<int>(
                              value: agendamento.id,
                              child: Text(
                                '$nome - $data',
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: _editando
                              ? null
                              : (valor) {
                                  setState(() {
                                    _agendamentoId = valor;
                                  });
                                },
                          validator: (valor) {
                            return valor == null
                                ? 'Selecione uma consulta'
                                : null;
                          },
                        ),

                        if (_agendamentos.isEmpty) ...[
                          const SizedBox(height: 12),
                          const Text(
                            'Nenhuma consulta disponível. '
                            'Crie um agendamento primeiro.',
                          ),
                        ],

                        const SizedBox(height: 20),

                        OutlinedButton.icon(
                          onPressed: _selecionarData,
                          icon: const Icon(
                            Icons.calendar_today_outlined,
                          ),
                          label: Text(
                            'Data: ${DateFormat('dd/MM/yyyy').format(_realizadoEm)}',
                          ),
                        ),

                        const SizedBox(height: 12),

                        OutlinedButton.icon(
                          onPressed: _selecionarHorario,
                          icon: const Icon(Icons.schedule),
                          label: Text(
                            'Horário: ${DateFormat('HH:mm').format(_realizadoEm)}',
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _observacaoController,
                          maxLines: 4,
                          maxLength: 500,
                          decoration: const InputDecoration(
                            labelText: 'Observação administrativa',
                            hintText:
                                'Ex.: Atendimento realizado presencialmente.',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                        ),

                        const SizedBox(height: 20),

                        FilledButton.icon(
                          onPressed: _salvando ||
                                  _agendamentos.isEmpty
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
                                : _editando
                                    ? 'Salvar alterações'
                                    : 'Registrar atendimento',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
