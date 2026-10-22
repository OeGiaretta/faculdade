
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/agendamento.dart';
import '../../models/paciente.dart';
import '../../repositories/agendamento_repository.dart';
import '../../repositories/paciente_repository.dart';
import '../../repositories/psicologo_repository.dart';
import 'agendamento_form_page.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  final _agendamentoRepository = AgendamentoRepository();
  final _pacienteRepository = PacienteRepository();
  final _psicologoRepository = PsicologoRepository();

  List<Agendamento> _agendamentos = [];
  Map<int, Paciente> _pacientes = {};

  bool _carregando = true;
  String? _erro;

  static const _corPrincipal = Color(0xFF587C78);

  @override
  void initState() {
    super.initState();
    _carregarAgenda();
  }

  Future<void> _carregarAgenda() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final psicologo =
          await _psicologoRepository.buscarPrimeiro();

      if (psicologo?.id == null) {
        throw Exception('Psicólogo não encontrado.');
      }

      final pacientes = await _pacienteRepository.listar(
        psicologo!.id!,
      );

      final agendamentos =
          await _agendamentoRepository.listar();

      if (!mounted) return;

      setState(() {
        _pacientes = {
          for (final paciente in pacientes)
            if (paciente.id != null)
              paciente.id!: paciente,
        };

        _agendamentos = agendamentos.where((agendamento) {
          return _pacientes.containsKey(
            agendamento.pacienteId,
          );
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

  Future<void> _abrirFormulario([
    Agendamento? agendamento,
  ]) async {
    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AgendamentoFormPage(
          agendamento: agendamento,
        ),
      ),
    );

    if (!mounted) return;

    if (resultado == true) {
      await _carregarAgenda();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agendamento salvo com sucesso!'),
        ),
      );
    }
  }

  Future<void> _alterarStatus(
    Agendamento agendamento,
    String status,
  ) async {
    try {
      await _agendamentoRepository.atualizarStatus(
        agendamento.id!,
        status,
      );

      await _carregarAgenda();
    } catch (erro) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $erro')),
      );
    }
  }

  Future<void> _excluir(Agendamento agendamento) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir agendamento'),
        content: const Text(
          'Deseja excluir esta consulta? '
          'Essa ação não poderá ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    try {
      await _agendamentoRepository.excluir(
        agendamento.id!,
      );

      await _carregarAgenda();
    } catch (erro) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $erro')),
      );
    }
  }

  String _nomePaciente(int id) {
    return _pacientes[id]?.nome ?? 'Paciente não encontrado';
  }

  String _statusTexto(String status) {
    switch (status) {
      case 'concluido':
        return 'Concluído';
      case 'cancelado':
        return 'Cancelado';
      case 'nao_compareceu':
        return 'Não compareceu';
      default:
        return 'Agendado';
    }
  }

  Color _corStatus(String status) {
    switch (status) {
      case 'concluido':
        return Colors.green;
      case 'cancelado':
        return Colors.red;
      case 'nao_compareceu':
        return Colors.orange;
      default:
        return _corPrincipal;
    }
  }

  Widget _construirLista() {
    if (_carregando) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_erro != null) {
      return Center(
        child: Text(_erro!),
      );
    }

    if (_agendamentos.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.event_busy_outlined,
              size: 70,
              color: _corPrincipal,
            ),
            const SizedBox(height: 16),
            const Text('Nenhum agendamento cadastrado.'),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => _abrirFormulario(),
              icon: const Icon(Icons.add),
              label: const Text('Nova consulta'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregarAgenda,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        itemCount: _agendamentos.length,
        itemBuilder: (context, index) {
          final agendamento = _agendamentos[index];

          final data = DateFormat('dd/MM/yyyy').format(
            agendamento.dataHoraInicio,
          );

          final inicio = DateFormat('HH:mm').format(
            agendamento.dataHoraInicio,
          );

          final fim = DateFormat('HH:mm').format(
            agendamento.dataHoraFim,
          );

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        color: _corPrincipal,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _nomePaciente(
                            agendamento.pacienteId,
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (acao) {
                          if (acao == 'editar') {
                            _abrirFormulario(agendamento);
                          } else if (acao == 'excluir') {
                            _excluir(agendamento);
                          } else {
                            _alterarStatus(
                              agendamento,
                              acao,
                            );
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: 'editar',
                            child: Text('Editar'),
                          ),
                          PopupMenuItem(
                            value: 'agendado',
                            child: Text('Marcar agendado'),
                          ),
                          PopupMenuItem(
                            value: 'concluido',
                            child: Text('Marcar concluído'),
                          ),
                          PopupMenuItem(
                            value: 'cancelado',
                            child: Text('Marcar cancelado'),
                          ),
                          PopupMenuItem(
                            value: 'nao_compareceu',
                            child: Text('Não compareceu'),
                          ),
                          PopupMenuDivider(),
                          PopupMenuItem(
                            value: 'excluir',
                            child: Text('Excluir'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('$data • $inicio às $fim'),
                  const SizedBox(height: 4),
                  Text(
                    agendamento.modalidade == 'online'
                        ? 'Online'
                        : 'Presencial',
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(
                      _statusTexto(agendamento.status),
                    ),
                    labelStyle: TextStyle(
                      color: _corStatus(
                        agendamento.status,
                      ),
                    ),
                    backgroundColor: _corStatus(
                      agendamento.status,
                    ).withValues(alpha: 0.10),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
        actions: [
          IconButton(
            onPressed: _carregarAgenda,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _construirLista(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        backgroundColor: _corPrincipal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nova consulta'),
      ),
    );
  }
}
