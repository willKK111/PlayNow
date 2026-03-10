import 'package:flutter/material.dart';
import 'package:play_now/domain/sessao.dart';
import 'package:play_now/domain/usuario.dart';
import 'package:play_now/domain/reserva.dart';
import 'package:play_now/domain/quadra.dart';
import 'package:play_now/service/reserva_service.dart';
import 'package:play_now/service/quadra_service.dart';
import 'package:play_now/ui/pages/admin/widgets/bottom_navbar_admin.dart';
import 'package:play_now/ui/pages/associado/widgets/bottom_navbar_associado.dart';

class ListaReservas extends StatefulWidget {
  const ListaReservas({super.key});

  @override
  State<ListaReservas> createState() => _ListaReservasState();
}

class _ListaReservasState extends State<ListaReservas> {
  late Future<List<Reserva>> _futurasReservas;
  late Future<Map<int, Quadra>> _futuroMapaQuadras;

  @override
  void initState() {
    super.initState();
    final usuarioLogado = Sessao.usuarioLogado!;

    _futurasReservas = ReservaService().buscarTodas().then((lista) {
      if (lista == null) return [];

      if (usuarioLogado.isAdmin) {
        return lista;
      } else {
        return lista.where((r) => r.idUsuario == usuarioLogado.id).toList();
      }
    });

    _futuroMapaQuadras = _carregarMapaQuadras();
  }


  Future<Map<int, Quadra>> _carregarMapaQuadras() async {
    final quadras = await QuadraService().buscarTodas() ?? [];
    return {for (var q in quadras) q.idQuadra: q};
  }

  @override
  Widget build(BuildContext context) {
    final usuario = Sessao.usuarioLogado!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceVariant,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'RESERVAS',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder(
                future: Future.wait([_futurasReservas, _futuroMapaQuadras]),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erro: ${snapshot.error}',
                        style: textTheme.bodyLarge?.copyWith(color: colorScheme.error),
                      ),
                    );
                  }

                  final reservas = snapshot.data![0] as List<Reserva>;
                  final mapaQuadras = snapshot.data![1] as Map<int, Quadra>;

                  if (reservas.isEmpty) {
                    return Center(
                      child: Text(
                        'Nenhuma reserva encontrada.',
                        style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: reservas.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: colorScheme.outlineVariant,
                    ),
                    itemBuilder: (context, index) {
                      final reserva = reservas[index];
                      final quadra = mapaQuadras[reserva.idQuadra];
                      final numeroQuadra = quadra?.numero ?? 0;
                      final nomeCategoria = quadra?.categoria.nome ?? 'Desconhecida';

                      final nomeExibido = 'Quadra nº $numeroQuadra - $nomeCategoria';

                      final data = reserva.dataHora;
                      final dataFormatada = '${data.day.toString().padLeft(2, '0')}/'
                          '${data.month.toString().padLeft(2, '0')}/'
                          '${data.year}';
                      final horaFormatada = '${data.hour.toString().padLeft(2, '0')}:'
                          '${data.minute.toString().padLeft(2, '0')}';

                      return ListTile(
                        title: Text(
                          nomeExibido,
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        subtitle: Text(
                          'Data: $dataFormatada  Horário: $horaFormatada',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/detalhes-reserva',
                            arguments: reserva,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar:
      usuario.isAdmin ? BottomNavBarAdmin() : BottomNavBarAssociado(),
    );
  }
}
