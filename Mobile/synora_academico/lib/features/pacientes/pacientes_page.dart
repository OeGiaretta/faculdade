
import 'package:flutter/material.dart';

import '../../models/paciente.dart';
import '../../repositories/paciente_repository.dart';
import '../../repositories/psicologo_repository.dart';
import 'paciente_form_page.dart';

class PacientesPage extends StatefulWidget {
  const PacientesPage({super.key});

  @override
  State<PacientesPage> createState() => _PacientesPageState();
}

class _PacientesPageState extends State<PacientesPage> {
  final PacienteRepository _pacienteRepository = PacienteRepository();
  final PsicologoRepository _psicologoRepository = PsicologoRepository();

  final TextEditingController _pesquisaController =
      TextEditingController();

  List<Paciente> _pacientes = [];
  List<Paciente> _pacientesFiltrados = [];

  bool _carregando = true;
  String? _erro;

  static const Color _corPrincipal = Color(0xFF587C78);

  @override
  void initState() {
    super.initState();
    _carregarPacientes();
  }

  @override
  void dispose() {
    _pesquisaController.dispose();
    super.dispose();
  }

  // Busca os pacientes cadastrados no SQLite.
  Future<void> _carregarPacientes() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final psicologo =
          await _psicologoRepository.buscarPrimeiro();

      if (psicologo?.id == null) {
        throw Exception(
          'Nenhum psicólogo cadastrado no aplicativo.',
        );
      }

      final pacientes = await _pacienteRepository.listar(
        psicologo!.id!,
      );

      if (!mounted) return;

      setState(() {
        _pacientes = pacientes;
        _carregando = false;
      });

      _filtrarPacientes();
    } catch (erro) {
      if (!mounted) return;

      setState(() {
        _erro = erro.toString();
        _carregando = false;
      });
    }
  }

  // Filtra a lista de pacientes pelo nome.
  void _filtrarPacientes() {
    final pesquisa = _pesquisaController.text
        .trim()
        .toLowerCase();

    setState(() {
      _pacientesFiltrados = _pacientes.where((paciente) {
        return paciente.nome.toLowerCase().contains(pesquisa);
      }).toList();
    });
  }

  // Abre o formulário para cadastrar ou editar.
  Future<void> _abrirFormulario([Paciente? paciente]) async {
    final resultado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PacienteFormPage(
          paciente: paciente,
        ),
      ),
    );

    if (!mounted) return;

    if (resultado == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            paciente == null
                ? 'Paciente cadastrado com sucesso!'
                : 'Paciente atualizado com sucesso!',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

      await _carregarPacientes();
    }
  }

  // Confirma e executa a exclusão do paciente.
  Future<void> _confirmarExclusao(Paciente paciente) async {
    if (paciente.id == null) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir paciente'),
          content: Text(
            'Deseja realmente excluir o paciente '
            '"${paciente.nome}"?\n\n'
            'Esta ação não poderá ser desfeita.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) return;

    try {
      final excluidos = await _pacienteRepository.excluir(
        paciente.id!,
      );

      if (!mounted) return;

      if (excluidos == 0) {
        throw Exception('Paciente não encontrado.');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Paciente excluído com sucesso!'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      await _carregarPacientes();
    } catch (erro) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível excluir o paciente. '
            'Ele pode possuir agendamentos vinculados.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Altera o status ativo/inativo.
  Future<void> _alternarStatus(Paciente paciente) async {
    if (paciente.id == null) return;

    try {
      final atualizado = Paciente(
        id: paciente.id,
        psicologoId: paciente.psicologoId,
        nome: paciente.nome,
        telefone: paciente.telefone,
        email: paciente.email,
        dataNascimento: paciente.dataNascimento,
        ativo: !paciente.ativo,
        criadoEm: paciente.criadoEm,
      );

      final alterados =
          await _pacienteRepository.atualizar(atualizado);

      if (alterados == 0) {
        throw Exception('Paciente não encontrado.');
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            atualizado.ativo
                ? 'Paciente ativado com sucesso!'
                : 'Paciente inativado com sucesso!',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

      await _carregarPacientes();
    } catch (erro) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao alterar status: $erro'),
        ),
      );
    }
  }

  // Monta a lista de pacientes.
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
              const Icon(
                Icons.error_outline,
                size: 56,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                'Erro ao carregar pacientes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _erro!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _carregarPacientes,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (_pacientesFiltrados.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.people_outline,
                size: 76,
                color: _corPrincipal,
              ),
              const SizedBox(height: 16),
              Text(
                _pacientes.isEmpty
                    ? 'Nenhum paciente cadastrado'
                    : 'Nenhum paciente encontrado',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _pacientes.isEmpty
                    ? 'Cadastre seu primeiro paciente '
                        'para começar a organizar '
                        'seus atendimentos.'
                    : 'Tente pesquisar por outro nome.',
                textAlign: TextAlign.center,
              ),
              if (_pacientes.isEmpty) ...[
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => _abrirFormulario(),
                  icon: const Icon(Icons.person_add),
                  label: const Text('Cadastrar paciente'),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregarPacientes,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        itemCount: _pacientesFiltrados.length,
        separatorBuilder: (_, _) =>
            const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final paciente = _pacientesFiltrados[index];

          return Card(
            elevation: 0,
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerLow,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFE1ECE9),
                child: Text(
                  paciente.nome.isNotEmpty
                      ? paciente.nome[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: _corPrincipal,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              title: Text(
                paciente.nome,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    paciente.telefone?.isNotEmpty == true
                        ? paciente.telefone!
                        : 'Telefone não informado',
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 9,
                        color: paciente.ativo
                            ? Colors.green
                            : Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        paciente.ativo ? 'Ativo' : 'Inativo',
                        style: TextStyle(
                          fontSize: 12,
                          color: paciente.ativo
                              ? Colors.green.shade700
                              : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () => _abrirFormulario(paciente),
              trailing: PopupMenuButton<String>(
                tooltip: 'Opções do paciente',
                onSelected: (acao) {
                  switch (acao) {
                    case 'editar':
                      _abrirFormulario(paciente);
                      break;

                    case 'status':
                      _alternarStatus(paciente);
                      break;

                    case 'excluir':
                      _confirmarExclusao(paciente);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'editar',
                    child: ListTile(
                      leading: Icon(Icons.edit_outlined),
                      title: Text('Editar'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'status',
                    child: ListTile(
                      leading: Icon(
                        paciente.ativo
                            ? Icons.person_off_outlined
                            : Icons.person_outline,
                      ),
                      title: Text(
                        paciente.ativo
                            ? 'Inativar'
                            : 'Ativar',
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'excluir',
                    child: ListTile(
                      leading: Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                      title: Text(
                        'Excluir',
                        style: TextStyle(color: Colors.red),
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
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
    final totalAtivos =
        _pacientes.where((paciente) => paciente.ativo).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
        actions: [
          IconButton(
            tooltip: 'Atualizar pacientes',
            onPressed: _carregarPacientes,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16, 8, 16, 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gerenciamento de pacientes',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Organize os cadastros e acompanhe '
                    'seus pacientes.',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _resumoCard(
                          'Total',
                          _pacientes.length.toString(),
                          Icons.people_outline,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _resumoCard(
                          'Ativos',
                          totalAtivos.toString(),
                          Icons.person_outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _pesquisaController,
                    onChanged: (_) => _filtrarPacientes(),
                    decoration: InputDecoration(
                      hintText: 'Pesquisar por nome...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _pesquisaController.text.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Limpar pesquisa',
                              onPressed: () {
                                _pesquisaController.clear();
                                _filtrarPacientes();
                              },
                              icon: const Icon(Icons.clear),
                            ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _construirLista(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        backgroundColor: _corPrincipal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Novo paciente'),
      ),
    );
  }

  Widget _resumoCard(
    String titulo,
    String valor,
    IconData icone,
  ) {
    return Card(
      elevation: 0,
      color: const Color(0xFFE1ECE9),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icone,
              color: _corPrincipal,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 12,
                      color: _corPrincipal,
                    ),
                  ),
                  Text(
                    valor,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _corPrincipal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
