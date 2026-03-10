import 'package:play_now/domain/associado.dart';
import 'package:play_now/domain/categoria.dart';
import 'package:play_now/domain/quadra.dart';
import 'package:play_now/domain/reserva.dart';
import 'package:play_now/domain/usuario.dart';
import 'package:play_now/service/categoria_service.dart';
import 'package:play_now/service/quadra_service.dart';
import 'package:play_now/service/usuario_service.dart';

class Administrador extends Usuario {
  int idAdministrador;

  Administrador({
    required this.idAdministrador,
    required String nome,
    required String email,
    required String telefone,
    required String senha,
  }) : super(
    id: idAdministrador,
    nome: nome,
    email: email,
    senha: senha,
    telefone: telefone,
    isAdmin: true,
  );

  Administrador.vazio()
      : idAdministrador = 0,
        super(
        id: 0,
        nome: '',
        email: '',
        senha: '',
        telefone: '',
        isAdmin: true,
      );

  Future<String?> cadastrarQuadra(Quadra quadra) async {
    final service = QuadraService();
    return await service.adicionar(quadra);
  }

  Future<String?> editarQuadra(Quadra quadra) async {
    final service = QuadraService();
    return await service.atualizar(quadra);
  }

  Future<String?> cadastrarCategoria(Categoria categoria) async {
    final service = CategoriaService();
    return await service.adicionar(categoria);
  }

  Future<String?> editarCategoria(Categoria categoria) async {
    final service = CategoriaService();
    return await service.atualizar(categoria);
  }

  Future<String?> cadastrarAssociado(Associado associado) async {
    final service = UsuarioService();
    return await service.adicionarAssociado(associado);
  }

  void cancelarReservaAssociado(Reserva reserva, int idAssociado){

  }

  Future<String?> cadastrarAdministrador(Administrador administrador) async {
    final service = UsuarioService();
    return await service.adicionarAdm(administrador);
  }

  Future<String?> atualizarAdministrador(Administrador administrador) async {
    final service = UsuarioService();
    return await service.atualizarUsuario(administrador);
  }




  factory Administrador.fromJson(Map<String, dynamic> json) {
    return Administrador(
      idAdministrador: json['idUsuario'],
      nome: json['nome'],
      senha: '',
      email: json['email'],
      telefone: json['telefone'],
    );
  }

}
