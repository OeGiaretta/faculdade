
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/psicologo.dart';
import '../../repositories/psicologo_repository.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final _formKey = GlobalKey<FormState>();
  final _repository = PsicologoRepository();

  final _nomeController = TextEditingController();
  final _crpController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();

  Psicologo? _psicologo;

  bool _carregando = true;
  bool _editando = false;
  bool _salvando = false;
  String? _erro;

  static const _corPrincipal = Color(0xFF587C78);

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _crpController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  Future<void> _carregarPerfil() async {
    try {
      final psicologo = await _repository.buscarPrimeiro();

      if (psicologo == null) {
        throw StateError('Psicólogo não encontrado.');
      }

      if (!mounted) return;

      setState(() {
        _psicologo = psicologo;
        _nomeController.text = psicologo.nome;
        _crpController.text = psicologo.crp ?? '';
        _emailController.text = psicologo.email ?? '';
        _telefoneController.text = psicologo.telefone ?? '';
        _carregando = false;
        _erro = null;
      });
    } catch (erro) {
      if (!mounted) return;

      setState(() {
        _erro = erro.toString();
        _carregando = false;
      });
    }
  }

  void _cancelarEdicao() {
    final psicologo = _psicologo;

    if (psicologo == null) return;

    setState(() {
      _nomeController.text = psicologo.nome;
      _crpController.text = psicologo.crp ?? '';
      _emailController.text = psicologo.email ?? '';
      _telefoneController.text = psicologo.telefone ?? '';
      _editando = false;
    });
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate() || _salvando) {
      return;
    }

    final atual = _psicologo;

    if (atual == null || atual.id == null) return;

    setState(() => _salvando = true);

    try {
      final atualizado = Psicologo(
        id: atual.id,
        nome: _nomeController.text.trim(),
        crp: _crpController.text.trim().isEmpty
            ? null
            : _crpController.text.trim(),
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        telefone: _telefoneController.text.trim().isEmpty
            ? null
            : _telefoneController.text.trim(),
      );

      final alterados = await _repository.atualizar(atualizado);

      if (alterados == 0) {
        throw StateError('Nenhum registro foi atualizado.');
      }

      if (!mounted) return;

      setState(() {
        _psicologo = atualizado;
        _editando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil atualizado com sucesso!'),
        ),
      );
    } catch (erro) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atualizar perfil: $erro'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _salvando = false);
      }
    }
  }

  Widget _campo({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? teclado,
    List<TextInputFormatter>? formatadores,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: !_editando,
      keyboardType: teclado,
      inputFormatters: formatadores,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        filled: !_editando,
        fillColor: !_editando
            ? Theme.of(context)
                .colorScheme
                .surfaceContainerLow
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu perfil'),
        actions: [
          if (!_carregando && _psicologo != null && !_editando)
            IconButton(
              tooltip: 'Editar perfil',
              onPressed: () {
                setState(() => _editando = true);
              },
              icon: const Icon(Icons.edit_outlined),
            ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _erro != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_erro!),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () {
                            setState(() => _carregando = true);
                            _carregarPerfil();
                          },
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
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
                        const CircleAvatar(
                          radius: 45,
                          backgroundColor: Color(0xFFE1ECE9),
                          child: Icon(
                            Icons.person_outline,
                            size: 48,
                            color: _corPrincipal,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _psicologo?.nome ?? '',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Perfil profissional',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),

                        _campo(
                          controller: _nomeController,
                          label: 'Nome completo *',
                          icon: Icons.person_outline,
                          validator: (valor) {
                            if (valor == null ||
                                valor.trim().isEmpty) {
                              return 'Informe o nome';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        _campo(
                          controller: _crpController,
                          label: 'CRP',
                          icon: Icons.badge_outlined,
                        ),

                        const SizedBox(height: 16),

                        _campo(
                          controller: _emailController,
                          label: 'E-mail',
                          icon: Icons.email_outlined,
                          teclado: TextInputType.emailAddress,
                          validator: (valor) {
                            final email = valor?.trim() ?? '';

                            if (email.isEmpty) return null;

                            final regex = RegExp(
                              r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                            );

                            if (!regex.hasMatch(email)) {
                              return 'Informe um e-mail válido';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        _campo(
                          controller: _telefoneController,
                          label: 'Telefone',
                          icon: Icons.phone_outlined,
                          teclado: TextInputType.phone,
                          formatadores: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9()+\-\s]'),
                            ),
                          ],
                        ),

                        if (_editando) ...[
                          const SizedBox(height: 28),

                          FilledButton.icon(
                            onPressed: _salvando ? null : _salvar,
                            style: FilledButton.styleFrom(
                              backgroundColor: _corPrincipal,
                              padding: const EdgeInsets.all(16),
                            ),
                            icon: const Icon(Icons.save_outlined),
                            label: Text(
                              _salvando
                                  ? 'Salvando...'
                                  : 'Salvar alterações',
                            ),
                          ),

                          const SizedBox(height: 12),

                          OutlinedButton(
                            onPressed:
                                _salvando ? null : _cancelarEdicao,
                            child: const Text('Cancelar'),
                          ),
                        ] else ...[
                          const SizedBox(height: 28),

                          OutlinedButton.icon(
                            onPressed: () {
                              setState(() => _editando = true);
                            },
                            icon: const Icon(Icons.edit_outlined),
                            label: const Text('Editar perfil'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
    );
  }
}
