
import 'package:flutter/material.dart';

import '../../models/paciente.dart';
import '../../repositories/paciente_repository.dart';
import '../../repositories/psicologo_repository.dart';

class PacienteFormPage extends StatefulWidget {
  final Paciente? paciente;

  const PacienteFormPage({
    super.key,
    this.paciente,
  });

  @override
  State<PacienteFormPage> createState() =>
      _PacienteFormPageState();
}

class _PacienteFormPageState extends State<PacienteFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();

  final _pacienteRepository = PacienteRepository();
  final _psicologoRepository = PsicologoRepository();

  DateTime? _dataNascimento;
  bool _ativo = true;
  bool _salvando = false;

  bool get _editando => widget.paciente != null;

  @override
  void initState() {
    super.initState();

    final paciente = widget.paciente;

    if (paciente != null) {
      _nomeController.text = paciente.nome;
      _telefoneController.text = paciente.telefone ?? '';
      _emailController.text = paciente.email ?? '';
      _ativo = paciente.ativo;

      if (paciente.dataNascimento != null) {
        _dataNascimento = DateTime.tryParse(
          paciente.dataNascimento!,
        );
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final agora = DateTime.now();

    final data = await showDatePicker(
      context: context,
      initialDate: _dataNascimento ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: agora,
      helpText: 'Data de nascimento',
    );

    if (data != null) {
      setState(() {
        _dataNascimento = data;
      });
    }
  }

  String _formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');

    return '$dia/$mes/${data.year}';
  }

  String? _dataParaBanco() {
    if (_dataNascimento == null) return null;

    final ano = _dataNascimento!.year;
    final mes = _dataNascimento!.month
        .toString()
        .padLeft(2, '0');
    final dia = _dataNascimento!.day
        .toString()
        .padLeft(2, '0');

    return '$ano-$mes-$dia';
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_salvando) return;

    setState(() {
      _salvando = true;
    });

    try {
      final psicologo =
          await _psicologoRepository.buscarPrimeiro();

      if (psicologo?.id == null) {
        throw Exception(
          'Nenhum psicólogo cadastrado no aplicativo.',
        );
      }

      final paciente = Paciente(
        id: widget.paciente?.id,
        psicologoId: psicologo!.id!,
        nome: _nomeController.text.trim(),
        telefone: _telefoneController.text.trim().isEmpty
            ? null
            : _telefoneController.text.trim(),
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        dataNascimento: _dataParaBanco(),
        ativo: _ativo,
      );

      if (_editando) {
        final alterados =
            await _pacienteRepository.atualizar(paciente);

        if (alterados == 0) {
          throw Exception('Paciente não encontrado.');
        }
      } else {
        await _pacienteRepository.inserir(paciente);
      }

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (erro) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar paciente: $erro'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _salvando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const corPrincipal = Color(0xFF587C78);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _editando ? 'Editar paciente' : 'Novo paciente',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),

                const CircleAvatar(
                  radius: 36,
                  backgroundColor: Color(0xFFE1ECE9),
                  child: Icon(
                    Icons.person_outline,
                    size: 38,
                    color: corPrincipal,
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  _editando
                      ? 'Informações do paciente'
                      : 'Cadastrar paciente',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                const Text(
                  'Preencha os dados para organizar '
                  'seus atendimentos.',
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                TextFormField(
                  controller: _nomeController,
                  textCapitalization:
                      TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nome completo *',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (valor) {
                    if (valor == null ||
                        valor.trim().length < 3) {
                      return 'Informe um nome válido';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _telefoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Telefone',
                    hintText: '(45) 99999-9999',
                    prefixIcon: Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  keyboardType:
                      TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (valor) {
                    if (valor == null ||
                        valor.trim().isEmpty) {
                      return null;
                    }

                    final email = valor.trim();

                    if (!RegExp(
                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                    ).hasMatch(email)) {
                      return 'Informe um e-mail válido';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                OutlinedButton.icon(
                  onPressed: _selecionarData,
                  icon: const Icon(
                    Icons.calendar_month_outlined,
                  ),
                  label: Text(
                    _dataNascimento == null
                        ? 'Selecionar data de nascimento'
                        : 'Nascimento: ${_formatarData(_dataNascimento!)}',
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),

                const SizedBox(height: 16),

                SwitchListTile(
                  title: const Text('Paciente ativo'),
                  subtitle: const Text(
                    'Indica se o paciente está '
                    'em acompanhamento.',
                  ),
                  value: _ativo,
                  onChanged: (valor) {
                    setState(() {
                      _ativo = valor;
                    });
                  },
                ),

                const SizedBox(height: 32),

                FilledButton.icon(
                  onPressed: _salvando ? null : _salvar,
                  icon: _salvando
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(
                    _salvando
                        ? 'Salvando...'
                        : _editando
                            ? 'Salvar alterações'
                            : 'Cadastrar paciente',
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: corPrincipal,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
