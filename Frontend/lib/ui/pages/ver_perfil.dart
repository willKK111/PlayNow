import 'package:flutter/material.dart';
import 'package:play_now/domain/sessao.dart';
import 'package:play_now/domain/usuario.dart';
import 'package:play_now/ui/pages/admin/widgets/bottom_navbar_admin.dart';
import 'package:play_now/ui/pages/associado/widgets/bottom_navbar_associado.dart';
import 'alterar_perfil.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = Sessao.usuarioLogado!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceVariant,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        title: Text(
          'PlayNow',
          style: textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary),
        ),
        automaticallyImplyLeading: false,
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
      bottomNavigationBar:
      usuario.isAdmin ? BottomNavBarAdmin() : BottomNavBarAssociado(),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Imagem de perfil
            Center(
              child: Image.asset('assets/logo.png', height: 130),
            ),
            const SizedBox(height: 20),

            // Seção de Perfil
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título e botão de editar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Perfil",
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AlterarPerfil(),
                              ),
                            );
                          },
                          icon: Icon(Icons.edit, color: colorScheme.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Card de Nome
                    _buildProfileCard(
                      icon: Icons.person_outline,
                      label: "Nome",
                      value: usuario.nome,
                      colorScheme: colorScheme,
                    ),
                    const SizedBox(height: 15),

                    // Card de Email
                    _buildProfileCard(
                      icon: Icons.email_outlined,
                      label: "Email",
                      value: usuario.email,
                      colorScheme: colorScheme,
                    ),
                    const SizedBox(height: 15),

                    // Card de Telefone
                    _buildProfileCard(
                      icon: Icons.phone_outlined,
                      label: "Telefone",
                      value: usuario.telefone,
                      colorScheme: colorScheme,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard({
    required IconData icon,
    required String label,
    required String value,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary, size: 28),
          const SizedBox(width: 12),
          Text(
            "$label: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}
