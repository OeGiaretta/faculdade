
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/agendamento.dart';
import '../../models/atendimento.dart';
import '../../models/paciente.dart';
import '../../repositories/agendamento_repository.dart';
import '../../repositories/atendimento_repository.dart';
import '../../repositories/paciente_repository.dart';
import '../../repositories/psicologo_repository.dart';
import 'atendimento_form_page.dart';

class AtendimentosPage extends StatefulWidget {
  const AtendimentosPage({super.key});

  @override
  State<AtendimentosPage> createState() =>
      _AtendimentosPageState();
}

class _AtendimentosPageState
    extends State<AtendimentosPage> {
  final _atendimentoRepository = AtendimentoRepository();
  final _agendamentoRepository = AgendamentoRepository();
  final _pacienteRepository = PacienteRepository();
  final _psicologoRepository = PsicologoRepository();

  List<Atendimento> _atendimentos = [];
  Map<int, Agendamento> _agendamentos = {};
  Map<int, Paciente> _pacientes = {};

  bool _carregando = true;
  String? _erro;

  static const _corPrincipal = Color(0xFF587C78);

  @override
  void initState() {
    super.initState();
    _carregarAtendimentos();
  }

  Future<void> _carregarAtendimentos() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

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

      if (!mounted) return;

      setState(() {
        _pacientes = pacientesMap;
        _agendamentos = agendamentosMap;
        _atendimentos = atendimentos.where((atendimento) {
          return agendamentosMap.containsKey(
            atendimento.agendamentoId,
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
    Atendimento? atendimento,
  ]) async {
    final resultado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AtendimentoFormPage(
          atendimento: atendimento,
        ),
      ),
    );

    if (!mounted) return;

    if (resultado == true) {
      await _carregarAtendimentos();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Atendimento salvo com sucesso!'),
        ),
      );
    }
  }

  Future<void> _excluir(Atendimento atendimento) async {
    if (atendimento.id == null) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir atendimento'),
        content: const Text(
          'Deseja realmente excluir este atendimento? '
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
      await _atendimentoRepository.excluir(atendimento.id!);

      await _carregarAtendimentos();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Atendimento excluído com sucesso!'),
        ),
      );
    } catch (erro) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao excluir atendimento: $erro'),
        ),
      );
    }
  }

  String _nomePaciente(Atendimento atendimento) {
    final agendamento =
        _agendamentos[atendimento.agendamentoId];

    if (agendamento == null) {
      return 'Agendamento não encontrado';
    }

    return _pacientes[agendamento.pacienteId]?.nome ??
        'Paciente não encontrado';
  }

  Widget _construirLista() {
    if (_carregando) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_erro != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_erro!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _carregarAtendimentos,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (_atendimentos.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.assignment_outlined,
              size: 72,
              color: _corPrincipal,
            ),
            const SizedBox(height: 16),
            const Text('Nenhum atendimento registrado.'),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => _abrirFormulario(),
              icon: const Icon(Icons.add),
              label: const Text('Registrar atendimento'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregarAtendimentos,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        itemCount: _atendimentos.length,
        itemBuilder: (context, index) {
          final atendimento = _atendimentos[index];

          final data = DateFormat(
            'dd/MM/yyyy HH:mm',
          ).format(atendimento.realizadoEm);

          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE1ECE9),
                child: Icon(
                  Icons.assignment_turned_in_outlined,
                  color: _corPrincipal,
                ),
              ),
              title: Text(
                _nomePaciente(atendimento),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text('Realizado em: $data'),
                  if (atendimento
                          .observacaoAdministrativa
                          ?.isNotEmpty ==
                      true) ...[
                    const SizedBox(height: 6),
                    Text(
                      atendimento.observacaoAdministrativa!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
              onTap: () => _abrirFormulario(atendimento),
              trailing: PopupMenuButton<String>(
                onSelected: (acao) {
                  if (acao == 'editar') {
                    _abrirFormulario(atendimento);
                  } else if (acao == 'excluir') {
                    _excluir(atendimento);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'editar',
                    child: Text('Editar'),
                  ),
                  PopupMenuItem(
                    value: 'excluir',
                    child: Text('Excluir'),
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
        title: const Text('Atendimentos'),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            onPressed: _carregarAtendimentos,
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
        label: const Text('Novo atendimento'),
      ),
    );
  }
}
