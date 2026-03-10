import 'package:flutter/material.dart';
import 'package:play_now/domain/reserva.dart';
import 'package:play_now/domain/sessao.dart';
import 'package:play_now/service/reserva_service.dart';
import 'package:play_now/ui/pages/associado/widgets/bottom_navbar_associado.dart';
import 'package:play_now/ui/widgets/reserva_card.dart';
import 'package:play_now/ui/widgets/metrica_card.dart';

class HomeAssociadoPage extends StatefulWidget {
  const HomeAssociadoPage({super.key});

  @override
  State<HomeAssociadoPage> createState() => _HomeAssociadoPageState();
}

class _HomeAssociadoPageState extends State<HomeAssociadoPage> {
  List reservas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    carregarReservas();
  }

  Future<void> carregarReservas() async {
    try {
      final idUsuarioLogado = Sessao.usuarioLogado!.id;
      print('ID usuário logado: $idUsuarioLogado');

      final response = await ReservaService().buscarTodas();

      if (response == null || response is! List) {
        throw Exception("Resposta inesperada do backend.");
      }

      // Remova a conversão JSON -> Reserva, pois response já tem Reservas
      final todasReservas = List<Reserva>.from(response);

      print('Total de reservas recebidas: ${todasReservas.length}');
      for (var r in todasReservas) {
        print('Reserva: idUsuario=${r.idUsuario}, dataHora=${r.dataHora}');
      }

      final reservasUsuario = todasReservas
          .where((reserva) => reserva.idUsuario == idUsuarioLogado)
          .toList();

      print('Reservas do usuário filtradas: ${reservasUsuario.length}');
      for (var r in reservasUsuario) {
        print('Reserva filtrada: idQuadra=${r.idQuadra}, dataHora=${r.dataHora}');
      }

      reservasUsuario.sort((a, b) => a.dataHora.compareTo(b.dataHora));

      setState(() {
        reservas = reservasUsuario;
        isLoading = false;
      });
      print('SetState executado, reservas.length: ${reservas.length}');
    } catch (e) {
      print('Erro ao carregar reservas: $e');
      setState(() => isLoading = false);
    }
  }

  void onReservaTap(String title) {
    print("Clicou em: $title");
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final nomeUsuario = Sessao.usuarioLogado?.nome ?? 'Usuário';

    return Scaffold(
      backgroundColor: colorScheme.surfaceVariant,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        automaticallyImplyLeading: false,
        title: Text(
          'PlayNow',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onPrimary,
          ),
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
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              'Bem-vindo, $nomeUsuario',
              style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
            ),
            const SizedBox(height: 16),
            MetricaCard(
              title: 'Quantidade de Reservas',
              value: '${reservas.length}',
              onTap: () => Navigator.pushNamed(context, '/reservas'),
              backgroundColor: colorScheme.primaryContainer,
              valueColor: colorScheme.onPrimaryContainer,
              titleColor: colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: reservas.isEmpty
                  ? Center(
                child: Text(
                  "Nenhuma reserva encontrada",
                  style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                ),
              )
                  : ListView.separated(
                padding: const EdgeInsets.only(bottom: 16),
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemCount: reservas.length,
                  itemBuilder: (context, index) {
                    final reserva = reservas[index] as Reserva;
                    final dataFormatada = "${reserva.dataHora.day.toString().padLeft(2, '0')}/${reserva.dataHora.month.toString().padLeft(2, '0')} ${reserva.dataHora.hour.toString().padLeft(2, '0')}:${reserva.dataHora.minute.toString().padLeft(2, '0')}";
                    return ReservaCard(
                      'Quadra ${reserva.idQuadra}',
                      dataFormatada,
                      onReservaTap,
                    );
                  }
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBarAssociado(),
    );
  }
}
