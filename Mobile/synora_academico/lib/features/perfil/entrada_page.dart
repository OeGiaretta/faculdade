
import 'package:flutter/material.dart';

import '../../repositories/psicologo_repository.dart';
import '../dashboard/dashboard_page.dart';

class EntradaPage extends StatefulWidget {
  const EntradaPage({super.key});

  @override
  State<EntradaPage> createState() => _EntradaPageState();
}

class _EntradaPageState extends State<EntradaPage> {
  final _repository = PsicologoRepository();

  bool _carregando = true;
  String _nomePsicologo = 'Psicólogo';
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    try {
      final psicologo = await _repository.buscarPrimeiro();

      if (!mounted) return;

      setState(() {
        _nomePsicologo = psicologo?.nome ?? 'Psicólogo';
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

  void _entrar() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const DashboardPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    const corPrincipal = Color(0xFF587C78);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _carregando
              ? const CircularProgressIndicator()
              : _erro != null
                  ? Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Erro ao carregar perfil: $_erro',
                        textAlign: TextAlign.center,
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.psychology_outlined,
                            size: 90,
                            color: corPrincipal,
                          ),

                          const SizedBox(height: 24),

                          Text(
                            'Synora',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: corPrincipal,
                                ),
                          ),

                          const SizedBox(height: 12),

                          const Text(
                            'Gestão de consultório psicológico',
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 36),

                          Text(
                            'Bem-vindo, $_nomePsicologo!',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge,
                          ),

                          const SizedBox(height: 32),

                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: _entrar,
                              icon: const Icon(Icons.login),
                              label: const Text('Entrar'),
                              style: FilledButton.styleFrom(
                                backgroundColor: corPrincipal,
                                padding: const EdgeInsets.all(16),
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
