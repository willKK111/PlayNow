import 'package:play_now/domain/usuario.dart';

class Associado extends Usuario {
  int idAssociado;

  Associado({
    required this.idAssociado,
    required String nome,
    required String email,
    required String telefone,
    required String senha,
  }) : super(
    id: idAssociado,
    nome: nome,
    email: email,
    senha: senha,
    telefone: telefone,
    isAdmin: false,
  );

  Associado.vazio()
      : idAssociado = 0,
        super(
        id: 0,
        nome: '',
        email: '',
        senha: '',
        telefone: '',
        isAdmin: false,
      );

  factory Associado.fromJson(Map<String, dynamic> json) {
    return Associado(
      idAssociado: json['idUsuario'],
      nome: json['nome'],
      senha: '',
      email: json['email'],
      telefone: json['telefone'],
    );
  }
}
