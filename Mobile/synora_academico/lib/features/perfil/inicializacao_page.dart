
import 'package:flutter/material.dart';

import '../../repositories/psicologo_repository.dart';
import '../dashboard/dashboard_page.dart';
import 'cadastro_psicologo_page.dart';

class InicializacaoPage extends StatefulWidget {
  const InicializacaoPage({super.key});

  @override
  State<InicializacaoPage> createState() =>
      _InicializacaoPageState();
}

class _InicializacaoPageState extends State<InicializacaoPage> {
  final _repository = PsicologoRepository();

  late final Future<bool> _possuiPsicologo;

  @override
  void initState() {
    super.initState();
    _possuiPsicologo = _verificarCadastro();
  }

  Future<bool> _verificarCadastro() async {
    final psicologo = await _repository.buscarPrimeiro();
    return psicologo != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _possuiPsicologo,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Erro ao carregar os dados: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        if (snapshot.data == true) {
          return const DashboardPage();
        }

        return const CadastroPsicologoPage();
      },
    );
  }
}
