import 'package:flutter/material.dart';
import 'package:play_now/domain/sessao.dart';
import 'package:play_now/service/quadra_service.dart';
import 'package:play_now/service/usuario_service.dart';
import 'package:play_now/ui/pages/admin/widgets/bottom_navbar_admin.dart';
import 'package:play_now/ui/widgets/metrica_card.dart';
import 'package:play_now/ui/widgets/reserva_card.dart';

import '../../../service/reserva_service.dart';

class HomeAdminPage extends StatefulWidget {
  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  int totalReservas = 0;
  int totalUsuarios = 0;
  int totalQuadras = 0;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final reservas = await ReservaService().buscarTodas();
    final usuarios = await UsuarioService().buscarTodos();
    final quadras = await QuadraService().buscarTodas();

    setState(() {
      totalReservas = reservas?.length ?? 0;
      totalUsuarios = usuarios?.length ?? 0;
      totalQuadras = quadras?.length ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final nomeUsuario = Sessao.usuarioLogado?.nome ?? 'Usuário';

    return Scaffold(
      backgroundColor: colorScheme.surfaceVariant,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        automaticallyImplyLeading: false,
        title: Text(
          'PlayNow',
          style: textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary),
        ),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: colorScheme.onPrimary),
            tooltip: 'Sair',
            onPressed: () {
              Sessao.logout();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              'Bem-vindo, $nomeUsuario',
              style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  MetricaCard(
                    title: 'Quantidade de Reservas',
                    value: '$totalReservas',
                    onTap: () => Navigator.pushNamed(context, '/reservas'),
                    backgroundColor: colorScheme.primaryContainer,
                    valueColor: colorScheme.onPrimaryContainer,
                    titleColor: colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  MetricaCard(
                    title: 'Quantidade de Associados',
                    value: '$totalUsuarios',
                    onTap: () => Navigator.pushNamed(context, '/usuarios'),
                    backgroundColor: colorScheme.secondaryContainer,
                    valueColor: colorScheme.onSecondaryContainer,
                    titleColor: colorScheme.secondary,
                  ),
                  const SizedBox(height: 12),
                  MetricaCard(
                    title: 'Quantidade de Quadras',
                    value: '$totalQuadras',
                    onTap: () => Navigator.pushNamed(context, '/quadras'),
                    backgroundColor: colorScheme.tertiaryContainer ?? colorScheme.surfaceVariant,
                    valueColor: colorScheme.onTertiaryContainer ?? colorScheme.onSurfaceVariant,
                    titleColor: colorScheme.tertiary ?? colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBarAdmin(),
    );
  }
}
