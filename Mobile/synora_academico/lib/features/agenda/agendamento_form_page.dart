
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/agendamento.dart';
import '../../models/paciente.dart';
import '../../repositories/agendamento_repository.dart';
import '../../repositories/paciente_repository.dart';
import '../../repositories/psicologo_repository.dart';

class AgendamentoFormPage extends StatefulWidget {
  final Agendamento? agendamento;

  const AgendamentoFormPage({
    super.key,
    this.agendamento,
  });

  @override
  State<AgendamentoFormPage> createState() =>
      _AgendamentoFormPageState();
}

class _AgendamentoFormPageState extends State<AgendamentoFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _agendamentoRepository = AgendamentoRepository();
  final _pacienteRepository = PacienteRepository();
  final _psicologoRepository = PsicologoRepository();

  List<Paciente> _pacientes = [];

  int? _pacienteId;
  DateTime _data = DateTime.now();
  TimeOfDay _horaInicio = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _horaFim = const TimeOfDay(hour: 10, minute: 0);

  String _modalidade = 'presencial';
  String _status = 'agendado';

  bool _carregando = true;
  bool _salvando = false;
  String? _erro;

  bool get _editando => widget.agendamento != null;

  @override
  void initState() {
    super.initState();

    final agendamento = widget.agendamento;

    if (agendamento != null) {
      _pacienteId = agendamento.pacienteId;
      _data = agendamento.dataHoraInicio;

      _horaInicio = TimeOfDay.fromDateTime(
        agendamento.dataHoraInicio,
      );

      _horaFim = TimeOfDay.fromDateTime(
        agendamento.dataHoraFim,
      );

      _modalidade = agendamento.modalidade;
      _status = agendamento.status;
    }

    _carregarPacientes();
  }

  Future<void> _carregarPacientes() async {
    try {
      final psicologo =
          await _psicologoRepository.buscarPrimeiro();

      if (psicologo?.id == null) {
        throw Exception('Psicólogo não encontrado.');
      }

      final pacientes = await _pacienteRepository.listar(
        psicologo!.id!,
      );

      if (!mounted) return;

      setState(() {
        // Inclui pacientes inativos apenas quando já
        // estão vinculados ao agendamento em edição.
        _pacientes = pacientes.where((paciente) {
          return paciente.ativo ||
              paciente.id == _pacienteId;
        }).toList();

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
      initialDate: _data,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (data != null) {
      setState(() => _data = data);
    }
  }

  Future<void> _selecionarHorario(bool inicio) async {
    final horario = await showTimePicker(
      context: context,
      initialTime: inicio ? _horaInicio : _horaFim,
    );

    if (horario != null) {
      setState(() {
        if (inicio) {
          _horaInicio = horario;
        } else {
          _horaFim = horario;
        }
      });
    }
  }

  DateTime _combinarDataHora(TimeOfDay horario) {
    return DateTime(
      _data.year,
      _data.month,
      _data.day,
      horario.hour,
      horario.minute,
    );
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate() || _salvando) {
      return;
    }

    final inicio = _combinarDataHora(_horaInicio);
    final fim = _combinarDataHora(_horaFim);

    if (!fim.isAfter(inicio)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'O horário final deve ser posterior ao inicial.',
          ),
        ),
      );
      return;
    }

    setState(() => _salvando = true);

    try {
      final agendamento = Agendamento(
        id: widget.agendamento?.id,
        pacienteId: _pacienteId!,
        dataHoraInicio: inicio,
        dataHoraFim: fim,
        modalidade: _modalidade,
        status: _status,
      );

      if (_editando) {
        await _agendamentoRepository.atualizar(agendamento);
      } else {
        await _agendamentoRepository.inserir(agendamento);
      }

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (erro) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar: $erro'),
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
          _editando ? 'Editar agendamento' : 'Nova consulta',
        ),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _erro != null
              ? Center(child: Text(_erro!))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          size: 64,
                          color: corPrincipal,
                        ),
                        const SizedBox(height: 20),

                        Text(
                          _editando
                              ? 'Editar consulta'
                              : 'Agendar consulta',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall,
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 28),

                        DropdownButtonFormField<int>(
                          initialValue: _pacienteId,
                          decoration: const InputDecoration(
                            labelText: 'Paciente *',
                            border: OutlineInputBorder(),
                            prefixIcon:
                                Icon(Icons.person_outline),
                          ),
                          items: _pacientes.map((paciente) {
                            return DropdownMenuItem<int>(
                              value: paciente.id,
                              child: Text(paciente.nome),
                            );
                          }).toList(),
                          onChanged: (valor) {
                            setState(() => _pacienteId = valor);
                          },
                          validator: (valor) {
                            return valor == null
                                ? 'Selecione um paciente'
                                : null;
                          },
                        ),

                        if (_pacientes.isEmpty) ...[
                          const SizedBox(height: 12),
                          const Text(
                            'Cadastre um paciente ativo antes '
                            'de criar uma consulta.',
                          ),
                        ],

                        const SizedBox(height: 20),

                        OutlinedButton.icon(
                          onPressed: _selecionarData,
                          icon: const Icon(
                            Icons.calendar_today_outlined,
                          ),
                          label: Text(
                            'Data: ${DateFormat('dd/MM/yyyy').format(_data)}',
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    _selecionarHorario(true),
                                icon: const Icon(
                                  Icons.schedule,
                                ),
                                label: Text(
                                  'Início: ${_horaInicio.format(context)}',
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    _selecionarHorario(false),
                                icon: const Icon(
                                  Icons.schedule,
                                ),
                                label: Text(
                                  'Fim: ${_horaFim.format(context)}',
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        DropdownButtonFormField<String>(
                          initialValue: _modalidade,
                          decoration: const InputDecoration(
                            labelText: 'Modalidade',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'presencial',
                              child: Text('Presencial'),
                            ),
                            DropdownMenuItem(
                              value: 'online',
                              child: Text('Online'),
                            ),
                          ],
                          onChanged: (valor) {
                            if (valor != null) {
                              setState(() => _modalidade = valor);
                            }
                          },
                        ),

                        if (_editando) ...[
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            initialValue: _status,
                            decoration: const InputDecoration(
                              labelText: 'Status',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'agendado',
                                child: Text('Agendado'),
                              ),
                              DropdownMenuItem(
                                value: 'concluido',
                                child: Text('Concluído'),
                              ),
                              DropdownMenuItem(
                                value: 'cancelado',
                                child: Text('Cancelado'),
                              ),
                              DropdownMenuItem(
                                value: 'nao_compareceu',
                                child: Text('Não compareceu'),
                              ),
                            ],
                            onChanged: (valor) {
                              if (valor != null) {
                                setState(() => _status = valor);
                              }
                            },
                          ),
                        ],

                        const SizedBox(height: 32),

                        FilledButton.icon(
                          onPressed: _salvando ||
                                  _pacientes.isEmpty
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
                                    : 'Agendar consulta',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
