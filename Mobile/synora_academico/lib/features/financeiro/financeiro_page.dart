
import 'package:flutter/material.dart';
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
import 'pagamento_form_page.dart';

class FinanceiroPage extends StatefulWidget {
  const FinanceiroPage({super.key});

  @override
  State<FinanceiroPage> createState() => _FinanceiroPageState();
}

class _FinanceiroPageState extends State<FinanceiroPage> {
  final _pagamentoRepository = PagamentoRepository();
  final _atendimentoRepository = AtendimentoRepository();
  final _agendamentoRepository = AgendamentoRepository();
  final _pacienteRepository = PacienteRepository();
  final _psicologoRepository = PsicologoRepository();

  final _moeda = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );

  List<Pagamento> _pagamentos = [];
  Map<int, Atendimento> _atendimentos = {};
  Map<int, Agendamento> _agendamentos = {};
  Map<int, Paciente> _pacientes = {};

  bool _carregando = true;
  String? _erro;

  static const _corPrincipal = Color(0xFF587C78);

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
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

      final pacientes =
          await _pacienteRepository.listar(psicologo!.id!);

      final agendamentos =
          await _agendamentoRepository.listar();

      final atendimentos =
          await _atendimentoRepository.listar();

      final pagamentos =
          await _pagamentoRepository.listar();

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

      final atendimentosMap = {
        for (final atendimento in atendimentos)
          if (atendimento.id != null &&
              agendamentosMap.containsKey(
                atendimento.agendamentoId,
              ))
            atendimento.id!: atendimento,
      };

      if (!mounted) return;

      setState(() {
        _pacientes = pacientesMap;
        _agendamentos = agendamentosMap;
        _atendimentos = atendimentosMap;
        _pagamentos = pagamentos.where((pagamento) {
          return atendimentosMap.containsKey(
            pagamento.atendimentoId,
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

  Future<void> _abrirFormulario([Pagamento? pagamento]) async {
    final resultado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PagamentoFormPage(
          pagamento: pagamento,
        ),
      ),
    );

    if (!mounted) return;

    if (resultado == true) {
      await _carregarDados();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pagamento salvo com sucesso!'),
        ),
      );
    }
  }

  Future<void> _marcarComoPago(Pagamento pagamento) async {
    if (pagamento.id == null) return;

    try {
      final alterados = await _pagamentoRepository.marcarComoPago(
        pagamento.id!,
      );

      if (alterados == 0) {
        throw StateError(
          'O pagamento não está pendente ou não foi encontrado.',
        );
      }

      await _carregarDados();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pagamento marcado como pago!'),
        ),
      );
    } catch (erro) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $erro')),
      );
    }
  }

  Future<void> _excluir(Pagamento pagamento) async {
    if (pagamento.id == null) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir pagamento'),
        content: const Text(
          'Deseja realmente excluir este pagamento?',
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
      await _pagamentoRepository.excluir(pagamento.id!);
      await _carregarDados();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pagamento excluído!'),
        ),
      );
    } catch (erro) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $erro')),
      );
    }
  }

  String _nomePaciente(Pagamento pagamento) {
    final atendimento = _atendimentos[pagamento.atendimentoId];

    if (atendimento == null) return 'Paciente desconhecido';

    final agendamento =
        _agendamentos[atendimento.agendamentoId];

    if (agendamento == null) return 'Paciente desconhecido';

    return _pacientes[agendamento.pacienteId]?.nome ??
        'Paciente desconhecido';
  }

  String _statusTexto(String status) {
    switch (status) {
      case 'pago':
        return 'Pago';
      case 'cancelado':
        return 'Cancelado';
      default:
        return 'Pendente';
    }
  }

  Color _statusCor(String status) {
    switch (status) {
      case 'pago':
        return Colors.green;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Widget _resumoFinanceiro() {
    final recebido = _pagamentos
        .where((pagamento) => pagamento.status == 'pago')
        .fold<double>(
          0,
          (total, pagamento) => total + pagamento.valor,
        );

    final pendente = _pagamentos
        .where((pagamento) => pagamento.status == 'pendente')
        .fold<double>(
          0,
          (total, pagamento) => total + pagamento.valor,
        );

    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 8),
                  const Text('Recebido'),
                  const SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _moeda.format(recebido),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(
                    Icons.schedule,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 8),
                  const Text('Pendente'),
                  const SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _moeda.format(pendente),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _conteudo() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_erro != null) {
      return Center(
        child: Text(_erro!, textAlign: TextAlign.center),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: _resumoFinanceiro(),
        ),
        Expanded(
          child: _pagamentos.isEmpty
              ? const Center(
                  child: Text('Nenhum pagamento registrado.'),
                )
              : RefreshIndicator(
                  onRefresh: _carregarDados,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      12, 0, 12, 100,
                    ),
                    itemCount: _pagamentos.length,
                    itemBuilder: (context, index) {
                      final pagamento = _pagamentos[index];

                      return Card(
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.all(12),
                          title: Text(
                            _nomePaciente(pagamento),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 6),
                              Text(
                                _moeda.format(pagamento.valor),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Status: ${_statusTexto(pagamento.status)}',
                                style: TextStyle(
                                  color: _statusCor(
                                    pagamento.status,
                                  ),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (pagamento.dataPagamento !=
                                  null)
                                Text(
                                  'Pago em: '
                                  '${DateFormat('dd/MM/yyyy').format(pagamento.dataPagamento!)}',
                                ),
                            ],
                          ),
                          onTap: () =>
                              _abrirFormulario(pagamento),
                          trailing: PopupMenuButton<String>(
                            onSelected: (acao) {
                              switch (acao) {
                                case 'editar':
                                  _abrirFormulario(pagamento);
                                  break;
                                case 'pagar':
                                  _marcarComoPago(pagamento);
                                  break;
                                case 'excluir':
                                  _excluir(pagamento);
                                  break;
                              }
                            },
                            itemBuilder: (_) => [
                              const PopupMenuItem(
                                value: 'editar',
                                child: Text('Editar'),
                              ),
                              if (pagamento.status ==
                                  'pendente')
                                const PopupMenuItem(
                                  value: 'pagar',
                                  child: Text('Marcar como pago'),
                                ),
                              const PopupMenuItem(
                                value: 'excluir',
                                child: Text('Excluir'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financeiro'),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            onPressed: _carregarDados,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _conteudo(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _corPrincipal,
        foregroundColor: Colors.white,
        onPressed: () => _abrirFormulario(),
        icon: const Icon(Icons.add),
        label: const Text('Novo pagamento'),
      ),
    );
  }
}
