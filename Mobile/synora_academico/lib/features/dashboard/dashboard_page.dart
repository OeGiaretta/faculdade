
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/agendamento.dart';
import '../../models/paciente.dart';
import '../../repositories/agendamento_repository.dart';
import '../../repositories/paciente_repository.dart';
import '../../repositories/psicologo_repository.dart';

import '../agenda/agenda_page.dart';
import '../atendimentos/atendimento_page.dart';
import '../financeiro/financeiro_page.dart';
import '../pacientes/pacientes_page.dart';
import '../perfil/perfil_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with WidgetsBindingObserver {
  static const Color _corPrincipal = Color(0xFF587C78);

  final _agendamentoRepository = AgendamentoRepository();
  final _pacienteRepository = PacienteRepository();
  final _psicologoRepository = PsicologoRepository();

  final _formatoData = DateFormat('dd/MM/yyyy');
  final _formatoHora = DateFormat('HH:mm');

  List<Agendamento> _agendamentos = [];
  Map<int, Paciente> _pacientes = {};

  String _nomePsicologo = '';
  bool _carregando = true;
  bool _proximosDias = false;
  String? _erro;

  DateTime _hoje = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _carregarDados();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _carregarDados();
    }
  }

  bool _mesmoDia(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  DateTime _somenteData(DateTime data) {
    return DateTime(data.year, data.month, data.day);
  }

  Future<void> _carregarDados() async {
    if (!mounted) return;

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

      final pacientesMap = <int, Paciente>{
        for (final paciente in pacientes)
          if (paciente.id != null) paciente.id!: paciente,
      };

      // Mostra somente consultas dos pacientes
      // pertencentes ao psicólogo cadastrado.
      final consultas = agendamentos.where((agendamento) {
        return pacientesMap.containsKey(
          agendamento.pacienteId,
        );
      }).toList();

      consultas.sort(
        (a, b) => a.dataHoraInicio.compareTo(
          b.dataHoraInicio,
        ),
      );

      if (!mounted) return;

      setState(() {
        _nomePsicologo = psicologo.nome;
        _pacientes = pacientesMap;
        _agendamentos = consultas;
        _hoje = DateTime.now();
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

  List<Agendamento> get _consultasHoje {
    return _agendamentos.where((agendamento) {
      return _mesmoDia(
        agendamento.dataHoraInicio,
        _hoje,
      );
    }).toList();
  }

  List<Agendamento> get _consultasProximosDias {
    final inicio = _somenteData(_hoje).add(
      const Duration(days: 1),
    );

    final fim = _somenteData(_hoje).add(
      const Duration(days: 8),
    );

    return _agendamentos.where((agendamento) {
      final data = agendamento.dataHoraInicio;

      return !data.isBefore(inicio) && data.isBefore(fim);
    }).toList();
  }

  int _contarStatus(
    List<Agendamento> consultas,
    String status,
  ) {
    return consultas.where((consulta) {
      return consulta.status == status;
    }).length;
  }

  String _nomePaciente(Agendamento agendamento) {
    return _pacientes[agendamento.pacienteId]?.nome ??
        'Paciente não encontrado';
  }

  String _textoStatus(String status) {
    switch (status) {
      case 'agendado':
        return 'Agendado';
      case 'concluido':
        return 'Concluído';
      case 'cancelado':
        return 'Cancelado';
      case 'nao_compareceu':
        return 'Não compareceu';
      default:
        return status;
    }
  }

  Color _corStatus(String status) {
    switch (status) {
      case 'agendado':
        return Colors.blue;
      case 'concluido':
        return Colors.green;
      case 'cancelado':
        return Colors.red;
      case 'nao_compareceu':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _iconeStatus(String status) {
    switch (status) {
      case 'agendado':
        return Icons.schedule;
      case 'concluido':
        return Icons.check_circle_outline;
      case 'cancelado':
        return Icons.cancel_outlined;
      case 'nao_compareceu':
        return Icons.person_off_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Future<void> _abrirPagina(Widget pagina) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => pagina,
      ),
    );

    if (!mounted) return;

    // Recarrega a agenda quando o usuário retorna.
    await _carregarDados();
  }

  Future<void> _sair() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sair'),
        content: const Text(
          'Deseja realmente sair do Synora?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    Navigator.of(context).pushNamedAndRemoveUntil(
      '/entrada',
      (route) => false,
    );
  }

  Widget _indicador({
    required String titulo,
    required int quantidade,
    required IconData icone,
    required Color cor,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 8,
        ),
        child: Column(
          children: [
            Icon(icone, color: cor, size: 24),
            const SizedBox(height: 8),
            Text(
              '$quantidade',
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                titulo,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resumoDoDia() {
    final consultas = _consultasHoje;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Resumo de hoje',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _indicador(
                titulo: 'Total',
                quantidade: consultas.length,
                icone: Icons.calendar_month_outlined,
                cor: _corPrincipal,
              ),
            ),
            Expanded(
              child: _indicador(
                titulo: 'Agendadas',
                quantidade: _contarStatus(
                  consultas,
                  'agendado',
                ),
                icone: Icons.schedule,
                cor: Colors.blue,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _indicador(
                titulo: 'Concluídas',
                quantidade: _contarStatus(
                  consultas,
                  'concluido',
                ),
                icone: Icons.check_circle_outline,
                cor: Colors.green,
              ),
            ),
            Expanded(
              child: _indicador(
                titulo: 'Canceladas',
                quantidade: _contarStatus(
                  consultas,
                  'cancelado',
                ),
                icone: Icons.cancel_outlined,
                cor: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Não compareceram: '
          '${_contarStatus(consultas, 'nao_compareceu')}',
          style: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _cardConsulta(Agendamento agendamento) {
    final cor = _corStatus(agendamento.status);
    final cancelado = agendamento.status == 'cancelado';

    final inicio = _formatoHora.format(
      agendamento.dataHoraInicio,
    );

    final fim = _formatoHora.format(
      agendamento.dataHoraFim,
    );

    final modalidade = agendamento.modalidade == 'online'
        ? 'Online'
        : 'Presencial';

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _abrirPagina(const AgendaPage()),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 4,
                height: 74,
                decoration: BoxDecoration(
                  color: cor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 55,
                child: Column(
                  children: [
                    Text(
                      inicio,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      fim,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      _nomePaciente(agendamento),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        decoration: cancelado
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          agendamento.modalidade == 'online'
                              ? Icons.videocam_outlined
                              : Icons.location_on_outlined,
                          size: 15,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          modalidade,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _iconeStatus(agendamento.status),
                          size: 16,
                          color: cor,
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            _textoStatus(agendamento.status),
                            style: TextStyle(
                              color: cor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _programacao() {
    final consultas = _proximosDias
        ? _consultasProximosDias
        : _consultasHoje;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Programação',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment<bool>(
              value: false,
              label: Text('Hoje'),
              icon: Icon(Icons.today),
            ),
            ButtonSegment<bool>(
              value: true,
              label: Text('Próximos 7 dias'),
              icon: Icon(Icons.date_range),
            ),
          ],
          selected: {_proximosDias},
          onSelectionChanged: (selecionado) {
            setState(() {
              _proximosDias = selecionado.first;
            });
          },
        ),
        const SizedBox(height: 16),
        if (consultas.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(
                    Icons.event_available_outlined,
                    size: 48,
                    color: _corPrincipal,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _proximosDias
                        ? 'Nenhuma consulta nos próximos 7 dias.'
                        : 'Nenhuma consulta para hoje.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          ..._construirConsultasAgrupadas(consultas),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => _abrirPagina(const AgendaPage()),
          icon: const Icon(Icons.calendar_month_outlined),
          label: const Text('Abrir agenda completa'),
        ),
      ],
    );
  }

  List<Widget> _construirConsultasAgrupadas(
    List<Agendamento> consultas,
  ) {
    final widgets = <Widget>[];
    DateTime? dataAnterior;

    for (final consulta in consultas) {
      final data = consulta.dataHoraInicio;

      if (_proximosDias &&
          (dataAnterior == null ||
              !_mesmoDia(dataAnterior, data))) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(
              top: 12,
              bottom: 10,
            ),
            child: Text(
              DateFormat(
                "EEEE, dd/MM",
                'pt_BR',
              ).format(data),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        );
      }

      widgets.add(_cardConsulta(consulta));
      dataAnterior = data;
    }

    return widgets;
  }

  Widget _cardModulo({
    required String titulo,
    required String descricao,
    required IconData icone,
    required Widget pagina,
  }) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE1ECE9),
          child: Icon(icone, color: _corPrincipal),
        ),
        title: Text(
          titulo,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(descricao),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _abrirPagina(pagina),
      ),
    );
  }

  Widget _modulos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Gerenciamento',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        _cardModulo(
          titulo: 'Pacientes',
          descricao: 'Cadastrar e gerenciar pacientes',
          icone: Icons.people_outline,
          pagina: const PacientesPage(),
        ),
        _cardModulo(
          titulo: 'Agenda',
          descricao: 'Agendar e acompanhar consultas',
          icone: Icons.calendar_month_outlined,
          pagina: const AgendaPage(),
        ),
        _cardModulo(
          titulo: 'Atendimentos',
          descricao: 'Registrar consultas realizadas',
          icone: Icons.assignment_turned_in_outlined,
          pagina: const AtendimentosPage(),
        ),
        _cardModulo(
          titulo: 'Financeiro',
          descricao: 'Gerenciar pagamentos',
          icone: Icons.account_balance_wallet_outlined,
          pagina: const FinanceiroPage(),
        ),
        _cardModulo(
          titulo: 'Meu perfil',
          descricao: 'Visualizar e editar dados profissionais',
          icone: Icons.person_outline,
          pagina: const PerfilPage(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Synora'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Atualizar programação',
            onPressed: _carregarDados,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Sair',
            onPressed: _sair,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _carregando
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _erro != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Erro ao carregar Dashboard:\n$_erro',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: _carregarDados,
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _carregarDados,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      const Icon(
                        Icons.psychology_outlined,
                        size: 52,
                        color: _corPrincipal,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Olá, $_nomePsicologo!',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Sua programação de '
                        '${_formatoData.format(_hoje)}',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      _resumoDoDia(),
                      const SizedBox(height: 28),
                      _programacao(),
                      const SizedBox(height: 32),
                      _modulos(),
                      const SizedBox(height: 32),
                      const Center(
                        child: Text(
                          'Synora Acadêmico • Gestão profissional',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
