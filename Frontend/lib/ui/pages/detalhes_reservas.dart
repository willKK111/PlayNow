import 'package:flutter/material.dart';
import 'package:play_now/domain/reserva.dart';
import 'package:play_now/domain/quadra.dart';
import 'package:play_now/domain/usuario.dart';
import 'package:play_now/domain/sessao.dart';
import 'package:play_now/service/quadra_service.dart';
import 'package:play_now/service/usuario_service.dart';
import 'package:play_now/service/reserva_service.dart';
import 'package:play_now/ui/pages/admin/widgets/bottom_navbar_admin.dart';
import 'package:play_now/ui/pages/associado/widgets/bottom_navbar_associado.dart';

class DetalhesReservaPage extends StatelessWidget {
  final Reserva reserva;

  const DetalhesReservaPage({super.key, required this.reserva});

  Future<Quadra?> _buscarQuadra() {
    return QuadraService().buscarPorId(reserva.idQuadra);
  }

  Future<Usuario?> _buscarUsuario() {
    return UsuarioService().buscarPorId(reserva.idUsuario);
  }

  Future<void> _cancelarReserva(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancelar Reserva'),
        content: const Text('Deseja realmente cancelar esta reserva?'),
        actions: [
          TextButton(child: const Text('Não'), onPressed: () => Navigator.pop(ctx, false)),
          TextButton(child: const Text('Sim'), onPressed: () => Navigator.pop(ctx, true)),
        ],
      ),
    );

    if (confirm == true) {
      final mensagem = await ReservaService().deletar(reserva.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mensagem ?? 'Reserva cancelada')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final usuario = Sessao.usuarioLogado!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Reserva'),
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
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
      bottomNavigationBar: usuario.isAdmin
          ? const BottomNavBarAdmin()
          : const BottomNavBarAssociado(),
      body: FutureBuilder<Quadra?>(
        future: _buscarQuadra(),
        builder: (context, quadraSnapshot) {
          return FutureBuilder<Usuario?>(
            future: _buscarUsuario(),
            builder: (context, usuarioSnapshot) {
              if (quadraSnapshot.connectionState != ConnectionState.done ||
                  usuarioSnapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              final quadra = quadraSnapshot.data;
              final usuarioReserva = usuarioSnapshot.data;
              print('Usuário: ${usuarioSnapshot.data?.nome}');

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: SingleChildScrollView(
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildInfo('Reservado por', usuarioReserva?.nome ?? 'Desconhecido'),
                            const SizedBox(height: 12),
                            _buildInfo('Quadra', quadra != null ? '${quadra.nome} - nº ${quadra.numero}' : 'Desconhecida'),
                            const SizedBox(height: 12),
                            _buildInfo('Categoria', quadra?.categoria.nome ?? 'Desconhecida'),
                            const SizedBox(height: 12),
                            _buildInfo('Data', '${reserva.dataHora.day.toString().padLeft(2, '0')}/${reserva.dataHora.month.toString().padLeft(2, '0')}/${reserva.dataHora.year}'),
                            const SizedBox(height: 12),
                            _buildInfo('Horário', '${reserva.dataHora.hour.toString().padLeft(2, '0')}:${reserva.dataHora.minute.toString().padLeft(2, '0')}'),
                            const SizedBox(height: 12),
                            _buildInfo('Pessoas', reserva.listaPessoas.isNotEmpty ? reserva.listaPessoas.join(', ') : 'Nenhuma'),
                            const SizedBox(height: 24),
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: () => _cancelarReserva(context),
                                icon: const Icon(Icons.cancel),
                                label: const Text('Cancelar Reserva'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
