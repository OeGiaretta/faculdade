
import 'package:flutter/material.dart';

import '../../models/psicologo.dart';
import '../../repositories/psicologo_repository.dart';

class CadastroPsicologoPage extends StatefulWidget {
  const CadastroPsicologoPage({super.key});

  @override
  State<CadastroPsicologoPage> createState() =>
      _CadastroPsicologoPageState();
}

class _CadastroPsicologoPageState
    extends State<CadastroPsicologoPage> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _crpController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();

  final _repository = PsicologoRepository();

  bool _salvando = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _crpController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_salvando) return;

    setState(() {
      _salvando = true;
    });

    try {
      final existente = await _repository.buscarPrimeiro();

      if (existente != null) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Já existe um profissional cadastrado.'),
          ),
        );

        Navigator.of(context).pushReplacementNamed('/dashboard');
        return;
      }

      final psicologo = Psicologo(
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

      await _repository.inserir(psicologo);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil cadastrado com sucesso!'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.of(context).pushReplacementNamed('/dashboard');
    } catch (erro) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao cadastrar profissional: $erro'),
          behavior: SnackBarBehavior.floating,
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
        title: const Text('Synora'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.psychology_outlined,
                      size: 72,
                      color: corPrincipal,
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Bem-vindo ao Synora',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Vamos configurar seu perfil profissional '
                      'para começar a gerenciar seus pacientes '
                      'e agendamentos.',
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    TextFormField(
                      controller: _nomeController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Nome completo',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return 'Informe seu nome completo';
                        }
                        if (valor.trim().length < 3) {
                          return 'Informe um nome válido';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _crpController,
                      decoration: const InputDecoration(
                        labelText: 'CRP',
                        hintText: 'Ex.: 08/12345',
                        prefixIcon: Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
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

                    TextFormField(
                      controller: _telefoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Telefone',
                        prefixIcon: Icon(Icons.phone_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 32),

                    FilledButton.icon(
                      onPressed: _salvando ? null : _cadastrar,
                      icon: _salvando
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.check_circle_outline),
                      label: Text(
                        _salvando
                            ? 'Salvando...'
                            : 'Concluir cadastro',
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: corPrincipal,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Os dados serão armazenados localmente '
                      'no dispositivo.',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
