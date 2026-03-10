import 'quadra.dart';
import 'usuario.dart';

class Reserva {
  final int id;
  final DateTime dataHora;
  final int idQuadra;
  final int idUsuario;
  final List<String> listaPessoas;

  Reserva({
    required this.id,
    required this.dataHora,
    required this.idQuadra,
    required this.idUsuario,
    required this.listaPessoas,
  });

  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      id: json['idReserva'],
      dataHora: DateTime.parse(json['dataHora']),
      idQuadra: json['idQuadra'],
      idUsuario: json['idUsuario'],
      listaPessoas: List<String>.from(json['listaPessoas']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "dataHora": dataHora.toIso8601String(),
      "idQuadra": idQuadra,
      "idUsuario": idUsuario,
      "listaPessoas": listaPessoas,
    };
  }
}