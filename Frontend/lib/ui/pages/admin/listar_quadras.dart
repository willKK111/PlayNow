import 'package:flutter/material.dart';
import 'package:play_now/domain/quadra.dart';
import 'package:play_now/domain/sessao.dart';
import 'package:play_now/service/quadra_service.dart';
import 'package:play_now/ui/pages/admin/detalhes_quadras.dart';
import 'package:play_now/ui/pages/admin/widgets/bottom_navbar_admin.dart';

class ListarQuadras extends StatefulWidget {
  const ListarQuadras({super.key});

  @override
  State<ListarQuadras> createState() => _ListarQuadrasState();
}

class _ListarQuadrasState extends State<ListarQuadras> {
  late Future<List<Quadra>> _futureQuadras;
  List<Quadra> _quadras = [];

  @override
  void initState() {
    super.initState();
    _futureQuadras = _buscarQuadras();
  }

  Future<List<Quadra>> _buscarQuadras() async {
    final service = QuadraService();
    final quadras = await service.buscarTodas();
    _quadras = quadras ?? [];
    return _quadras;
  }

  void _atualizarQuadraNaLista(Quadra quadraAtualizada) {
    final index = _quadras.indexWhere((q) => q.idQuadra == quadraAtualizada.idQuadra);
    if (index != -1) {
      setState(() {
        _quadras[index] = quadraAtualizada;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceVariant,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
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
      body: FutureBuilder<List<Quadra>>(
        future: _futureQuadras,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text(
                'Erro ao carregar quadras',
                style: TextStyle(color: colorScheme.error),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'QUADRAS',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.separated(
                    itemCount: _quadras.length,
                    separatorBuilder: (_, __) => Divider(height: 1, color: colorScheme.outline),
                    itemBuilder: (context, index) {
                      final quadra = _quadras[index];
                      return ListTile(
                        title: Text(
                          'Quadra ${quadra.numero}',
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        subtitle: Text(
                          quadra.categoria.nome,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: colorScheme.onSurfaceVariant),
                        onTap: () async {
                          final quadraAtualizada = await Navigator.push<Quadra>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalhesQuadraPage(quadra: quadra),
                            ),
                          );

                          if (quadraAtualizada != null) {
                            _atualizarQuadraNaLista(quadraAtualizada);
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBarAdmin(),
    );
  }
}
