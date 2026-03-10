import 'package:flutter/material.dart';
import 'package:play_now/ui/pages/associado/home_associado.dart';
import 'package:play_now/ui/pages/reserva_page.dart';
import 'package:play_now/ui/pages/ver_perfil.dart';

class BottomNavBarAssociado extends StatelessWidget {
  const BottomNavBarAssociado({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    const baseHeight = 56.0;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(30),
        color: Colors.transparent,
        child: Container(
          height: baseHeight + bottomPadding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                context,
                icon: Icons.calendar_today,
                destination: const ReservaPage(),
              ),
              _buildNavItem(
                context,
                icon: Icons.home,
                destination: const HomeAssociadoPage(),
              ),
              _buildNavItem(
                context,
                icon: Icons.person,
                destination: const PerfilPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, {required IconData icon, required Widget destination}) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      icon: Icon(icon, color: colorScheme.onSurface, size: 26),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => destination),
        );
      },
    );
  }
}
