import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_now/ui/pages/admin/cadastro_associado.dart';
import 'package:play_now/ui/pages/reserva_page.dart';
import 'package:play_now/ui/pages/ver_perfil.dart';
import 'package:play_now/ui/pages/admin/cadastro_categoria.dart';
import 'package:play_now/ui/pages/admin/cadastro_quadra.dart';
import 'package:play_now/ui/pages/admin/home_admin_page.dart';

class BottomNavBarAdmin extends StatelessWidget {
  const BottomNavBarAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    const baseHeight = 50.0;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Material(
        elevation: 6,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: colorScheme.surfaceVariant, // substituído por cor válida
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          height: baseHeight + bottomPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.home),
                color: colorScheme.onSurface,
                iconSize: 24,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeAdminPage()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.add),
                color: colorScheme.onSurface,
                iconSize: 24,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    backgroundColor: colorScheme.surface,
                    builder: (_) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          listTileTheme: ListTileThemeData(
                            textColor: colorScheme.onSurface,
                            iconColor: colorScheme.onSurface,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: const Text('Cadastrar Quadra'),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CadastroQuadraPage()),
                                );
                              },
                            ),
                            const Divider(height: 1),
                            ListTile(
                              title: const Text('Cadastrar Associado'),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CadastroNovoUsuarioAdmin()),
                                );
                              },
                            ),
                            const Divider(height: 1),
                            ListTile(
                              title: const Text('Cadastrar Categoria'),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CadastroCategoriaAdmin()),
                                );
                              },
                            ),
                            SizedBox(height: bottomPadding),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.calendar_today),
                color: colorScheme.onSurface,
                iconSize: 24,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReservaPage()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.person),
                color: colorScheme.onSurface,
                iconSize: 24,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PerfilPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
