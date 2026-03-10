import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:play_now/domain/sessao.dart';
import 'package:play_now/domain/usuario.dart';
import 'package:play_now/ui/pages/admin/widgets/bottom_navbar_admin.dart';
import 'package:play_now/ui/pages/associado/widgets/bottom_navbar_associado.dart';
import '../../domain/reserva.dart';
import '../../domain/quadra.dart';
import '../../service/reserva_service.dart';
import '../../service/quadra_service.dart';
import 'associado/widgets/expandable_button.dart';

class ReservaPage extends StatefulWidget {
  const ReservaPage({super.key});

  @override
  _ReservaPageState createState() => _ReservaPageState();
}

class _ReservaPageState extends State<ReservaPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<Quadra> _quadras = [];
  List<String> _availableCourts = [];
  Map<String, List<String>> _availableTimesByCourt = {};
  String? _selectedCourt;
  String? _selectedTime;

  bool _isLoadingCourtsAndTimes = false;
  bool _isConfirmingReservation = false;

  final ReservaService _reservaService = ReservaService();
  final QuadraService _quadraService = QuadraService();

  // NOVAS VARIÁVEIS PARA LISTA DE PESSOAS
  final TextEditingController _pessoaController = TextEditingController();
  List<String> _listaPessoas = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _fetchQuadras();
    _fetchCourtsAndTimesForSelectedDate();
  }

  @override
  void dispose() {
    _pessoaController.dispose();
    super.dispose();
  }

  Future<void> _fetchQuadras() async {
    try {
      final quadras = await _quadraService.buscarTodas();
      setState(() {
        _quadras = quadras ?? [];
      });
    } catch (e) {
      _showSnackBar('Erro ao buscar quadras: ${e.toString()}');
    }
  }

  Future<void> _fetchCourtsAndTimesForSelectedDate() async {
    if (_selectedDay == null) {
      _showSnackBar('Por favor, selecione uma data para ver as disponibilidades.');
      return;
    }

    setState(() {
      _isLoadingCourtsAndTimes = true;
      _availableCourts = [];
      _availableTimesByCourt = {};
      _selectedCourt = null;
      _selectedTime = null;
    });

    try {
      final data = await _reservaService.buscarHorariosDisponiveis(_selectedDay!);
      setState(() {
        _availableTimesByCourt = data;
        _availableCourts = data.keys
            .where((nome) => _quadras.any((q) => q.nome.trim().toLowerCase() == nome.trim().toLowerCase()))
            .toList();
      });

      if (_availableCourts.isEmpty) {
        _showSnackBar('Nenhuma quadra disponível para a data selecionada.', isError: false);
      }
    } catch (e) {
      _showSnackBar('Erro ao buscar disponibilidades: ${e.toString()}');
    } finally {
      setState(() {
        _isLoadingCourtsAndTimes = false;
      });
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  List<String> _getTimesForSelectedCourt() {
    if (_selectedCourt != null && _availableTimesByCourt.containsKey(_selectedCourt)) {
      return _availableTimesByCourt[_selectedCourt]!;
    }
    return [];
  }

  Future<void> _confirmReservation() async {
    if (_selectedDay == null || _selectedCourt == null || _selectedTime == null) {
      _showSnackBar('Por favor, selecione a data, a quadra e o horário para confirmar a reserva.');
      return;
    }

    final quadraSelecionada = _quadras.firstWhere(
          (q) => q.nome == _selectedCourt,
      orElse: () => throw Exception('Quadra não encontrada'),
    );
    final int idQuadra = quadraSelecionada.idQuadra;

    final int? idUsuario = Sessao.usuarioLogado?.id;
    if (idUsuario == null) {
      _showSnackBar('Erro: Usuário não logado. Por favor, faça login novamente.');
      return;
    }

    setState(() {
      _isConfirmingReservation = true;
    });

    try {
      final String dateTimeString = '${_selectedDay!.toIso8601String().split('T')[0]}T$_selectedTime:00';
      final DateTime reservationDateTime = DateTime.parse(dateTimeString);

      final Reserva novaReserva = Reserva(
        id: 0,
        dataHora: reservationDateTime,
        idQuadra: idQuadra,
        idUsuario: idUsuario,
        listaPessoas: _listaPessoas,
      );

      final String? result = await _reservaService.adicionar(novaReserva);

      if (result != null) {
        _showSnackBar('Reserva realizada com sucesso: $result', isError: false);
        setState(() {
          _selectedDay = DateTime.now();
          _focusedDay = DateTime.now();
          _selectedCourt = null;
          _selectedTime = null;
          _availableCourts = [];
          _availableTimesByCourt = {};
          _listaPessoas = [];
        });
        _fetchCourtsAndTimesForSelectedDate();
      } else {
        _showSnackBar('Falha ao realizar reserva. Tente novamente.');
      }
    } catch (e) {
      _showSnackBar('Erro ao confirmar reserva: ${e.toString()}');
    } finally {
      setState(() {
        _isConfirmingReservation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuario = Sessao.usuarioLogado!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final bool canConfirm = _selectedDay != null &&
        _selectedCourt != null &&
        _selectedTime != null &&
        !_isLoadingCourtsAndTimes &&
        !_isConfirmingReservation;

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
      bottomNavigationBar: usuario.isAdmin
          ? const BottomNavBarAdmin()
          : const BottomNavBarAssociado(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Datas disponíveis",
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.normal,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        _fetchCourtsAndTimesForSelectedDate();
                      });
                    },
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      defaultTextStyle: TextStyle(color: colorScheme.onSurface),
                      todayTextStyle: TextStyle(color: colorScheme.onSecondary),
                      selectedTextStyle: TextStyle(color: colorScheme.onPrimary),
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: textTheme.titleMedium!,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ExpandableButton(
                title: "Quadras Disponíveis",
                options: _availableCourts,
                isLoading: _isLoadingCourtsAndTimes,
                onTapHeader: _fetchCourtsAndTimesForSelectedDate,
                onOptionSelected: (court) {
                  setState(() {
                    _selectedCourt = court;
                    _selectedTime = null;
                  });
                },
                selectedOption: _selectedCourt,
                isDisabled: _isLoadingCourtsAndTimes && _availableCourts.isEmpty,
              ),
              const SizedBox(height: 10),
              ExpandableButton(
                title: "Horários Disponíveis",
                options: _getTimesForSelectedCourt(),
                isLoading: _isLoadingCourtsAndTimes,
                onTapHeader: () {
                  if (_selectedDay == null) {
                    _showSnackBar('Por favor, selecione uma data primeiro.');
                  } else if (_selectedCourt == null) {
                    _showSnackBar('Por favor, selecione uma quadra primeiro.');
                  }
                },
                onOptionSelected: (time) {
                  setState(() {
                    _selectedTime = time;
                  });
                },
                selectedOption: _selectedTime,
                isDisabled: _selectedCourt == null || _selectedDay == null || _isLoadingCourtsAndTimes,
              ),

              // ======== BLOCO MELHORADO: ADICIONAR PESSOAS ===========

              const SizedBox(height: 20),

              Row(
                children: [
                  Icon(Icons.group, color: colorScheme.primary, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    "Pessoas na Reserva",
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _pessoaController,
                          decoration: InputDecoration(
                            labelText: 'Nome da pessoa',
                            border: InputBorder.none,
                            hintText: 'Digite o nome',
                            prefixIcon: Icon(Icons.person),
                          ),
                          textCapitalization: TextCapitalization.words,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onPressed: () {
                          final nome = _pessoaController.text.trim();
                          if (nome.isNotEmpty) {
                            setState(() {
                              _listaPessoas.add(nome);
                              _pessoaController.clear();
                            });
                          }
                        },
                        child: const Icon(Icons.person_add_alt_1),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _listaPessoas.map((pessoa) {
                  return Chip(
                    label: Text(pessoa),
                    deleteIcon: Icon(Icons.close, size: 18),
                    onDeleted: () {
                      setState(() {
                        _listaPessoas.remove(pessoa);
                      });
                    },
                    backgroundColor: colorScheme.primary.withOpacity(0.2),
                    labelStyle: TextStyle(color: colorScheme.primary),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),

              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: canConfirm ? _confirmReservation : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isConfirmingReservation
                        ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onPrimary,
                      ),
                    )
                        : Text(
                      'Confirmar Reserva',
                      style: textTheme.titleMedium?.copyWith(color: colorScheme.onPrimary),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
