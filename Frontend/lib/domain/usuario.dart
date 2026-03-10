import 'package:play_now/domain/reserva.dart';

abstract class Usuario {
  int id;
  String nome;
  String email;
  String senha;
  String telefone;
  bool isAdmin;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.telefone,
    required this.isAdmin,
  });

  void fazerReserva(Reserva reserva) {}

  void cancelarReserva(Reserva reserva) {}
}
