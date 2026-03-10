import 'package:flutter/material.dart';
import 'package:play_now/domain/sessao.dart';
import 'package:play_now/domain/usuario.dart';
import 'package:play_now/provider/usuario_provider.dart';
import 'package:play_now/ui/pages/admin/editar_usuario.dart';
import 'package:play_now/ui/pages/admin/widgets/bottom_navbar_admin.dart';
import 'package:provider/provider.dart';

class DetalhesUsuarioPage extends StatefulWidget {
  final Usuario usuario;

  const DetalhesUsuarioPage({super.key, required this.usuario});

  @override
  State<DetalhesUsuarioPage> createState() => _DetalhesUsuarioPageState();
}

class _DetalhesUsuarioPageState extends State<DetalhesUsuarioPage> {
  late Usuario usuarioDetalhado;

  @override
  void initState() {
    super.initState();
    usuarioDetalhado = widget.usuario;
  }

  void atualizarUsuario(Usuario novoUsuario) {
    setState(() {
      usuarioDetalhado = novoUsuario;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
        title: Text(
          'Detalhes de ${usuarioDetalhado.nome}',
          style: theme.textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary),
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Card(
                elevation: 6,
                color: colorScheme.surfaceContainerHigh,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoTile(
                        context,
                        icon: Icons.person,
                        label: 'Nome',
                        value: usuarioDetalhado.nome,
                      ),
                      const SizedBox(height: 16),
                      _infoTile(
                        context,
                        icon: Icons.email,
                        label: 'Email',
                        value: usuarioDetalhado.email,
                      ),
                      const SizedBox(height: 16),
                      _infoTile(
                        context,
                        icon: Icons.phone,
                        label: 'Telefone',
                        value: usuarioDetalhado.telefone,
                      ),
                      const SizedBox(height: 16),
                      _infoTile(
                        context,
                        icon: Icons.security,
                        label: 'Tipo',
                        value: usuarioDetalhado.isAdmin ? 'Administrador' : 'Associado',
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit, color: colorScheme.primary),
                tooltip: 'Editar',
                onPressed: () async {
                  final resultado = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditarUsuarioPage(usuario: usuarioDetalhado),
                    ),
                  );

                  if (resultado is Usuario) {
                    context.read<UsuarioProvider>().atualizarUsuario(resultado);
                    atualizarUsuario(resultado);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBarAdmin(),
    );
  }

  Widget _infoTile(BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
