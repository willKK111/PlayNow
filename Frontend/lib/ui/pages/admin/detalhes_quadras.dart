import 'package:flutter/material.dart';
import 'package:play_now/domain/quadra.dart';
import 'package:play_now/domain/sessao.dart';
import 'package:play_now/provider/quadra_provider.dart';
import 'package:play_now/service/quadra_service.dart';
import 'package:play_now/ui/pages/admin/widgets/bottom_navbar_admin.dart';
import 'package:provider/provider.dart';

class DetalhesQuadraPage extends StatelessWidget {
  final Quadra quadra;

  const DetalhesQuadraPage({super.key, required this.quadra});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuadraProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final atual = provider.quadra;
      if (atual == null || atual.idQuadra != quadra.idQuadra) {
        Provider.of<QuadraProvider>(context, listen: false).setQuadra(quadra);
      }
    });

    final quadraProvider = provider.quadra ?? quadra;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
        title: Text(
          'Detalhes da Quadra',
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),
                    _infoTile(context, Icons.confirmation_number, 'Código', quadraProvider.numero.toString()),
                    const SizedBox(height: 16),
                    _infoTile(context, Icons.abc, 'Nome', quadraProvider.nome.toString()),
                    const SizedBox(height: 16),
                    _infoTile(context, Icons.category, 'Categoria', quadraProvider.categoria.nome),
                    const SizedBox(height: 16),
                    _infoTile(context, Icons.people, 'Capacidade Máxima', '${quadraProvider.maximoPessoas} pessoas'),
                  ],
                ),
              ),
              // Ícone de deletar - à direita, com espaço entre os dois ícones
              Positioned(
                top: 4,
                right: 48, // Ajuste para não sobrepor o ícone editar
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Deletar',
                  onPressed: () async {
                    final confirmou = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirmar deleção'),
                        content: const Text('Deseja realmente deletar esta quadra?'),
                        actions: [
                          TextButton(
                            child: const Text('Cancelar'),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          ElevatedButton(
                            child: const Text('Deletar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ],
                      ),
                    );

                    if (confirmou == true) {
                      final mensagem = await QuadraService().deletar(quadraProvider.idQuadra);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(mensagem ?? 'Quadra deletada')),
                        );
                        if (mensagem == null || mensagem.contains('sucesso')) {
                          Navigator.of(context).pop(true); // Fecha a tela e indica sucesso
                        }
                      }
                    }
                  },
                ),
              ),

              // Ícone de editar original, posicionado no canto superior direito
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  icon: Icon(Icons.edit, color: colorScheme.primary),
                  tooltip: 'Editar',
                  onPressed: () async {
                    final quadraAtualizada = await Navigator.pushNamed(
                      context,
                      '/editar-quadra',
                      arguments: quadraProvider,
                    ) as Quadra?;

                    if (quadraAtualizada != null) {
                      Provider.of<QuadraProvider>(context, listen: false).atualizarQuadra(quadraAtualizada);
                    }
                  },
                ),
              ),
            ],
          ),

        ),
      ),
      bottomNavigationBar: BottomNavBarAdmin(),
    );
  }

  Widget _infoTile(BuildContext context, IconData icon, String label, String value) {
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
                style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: colorScheme.onSurface),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
