import 'package:dio/dio.dart';
import 'package:play_now/domain/administrador.dart';
import 'package:play_now/domain/associado.dart';
import 'package:play_now/domain/usuario.dart';
import 'package:play_now/functions/tratar_erro.dart';
import 'package:play_now/service/api_cliente.dart';

class UsuarioService {

  Future<String?> adicionarAdm(Administrador administrador) async {
    try {
      final response = await ApiCliente.dio.post('/usuario',
        data: {
          'nome': administrador.nome,
          'email': administrador.email,
          'senha': administrador.senha,
          'telefone': administrador.telefone,
          'isAdmin': true,
        },
      );

      return response.statusCode == 200 || response.statusCode == 201
          ? 'Administrador cadastrado com sucesso!'
          : 'Erro ao cadastrar administrador.';
    } on DioException catch (e) {
      return ErroException.tratarErro(e);
    }
  }

  Future<String?> adicionarAssociado(Associado associado) async {
    try {
      final response = await ApiCliente.dio.post('/usuario',
        data: {
          'nome': associado.nome,
          'email': associado.email,
          'senha': associado.senha,
          'telefone': associado.telefone,
          'isAdmin': false,
        },
      );

      return response.statusCode == 200 || response.statusCode == 201
          ? 'Associado cadastrado com sucesso!'
          : 'Erro ao cadastrar associado.';
    } on DioException catch (e) {
      return ErroException.tratarErro(e);
    }
  }

  Future<Usuario?> buscarPorId(int id) async {
    try {
      final response = await ApiCliente.dio.get('/usuario/$id');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['isAdmin'] == true) {
          return Administrador.fromJson(data);
        } else {
          return Associado.fromJson(data);
        }
      }
    } on DioException catch (e) {
      throw Exception(ErroException.tratarErro(e));
    }
    return null;
  }


  Future<List<Usuario>> buscarTodos() async {
    try {
      final response = await ApiCliente.dio.get('/usuario/selecionarTodos');
      if (response.statusCode == 200) {
        final List dados = response.data;
        return dados.map<Usuario>((json) {
          return json['isAdmin'] == true
              ? Administrador.fromJson(json)
              : Associado.fromJson(json);
        }).toList();
      }
    } on DioException catch (e) {
      throw Exception(ErroException.tratarErro(e));
    }
    return [];
  }

  Future<String?> atualizarUsuario(Usuario usuario) async {
    try {
      int id;
      if (usuario is Administrador) {
        id = usuario.idAdministrador;
      } else if (usuario is Associado) {
        id = usuario.idAssociado;
      } else {
        return 'Tipo de usuário desconhecido.';
      }

      final response = await ApiCliente.dio.put(
        '/usuario/$id',
        data: {
          'nome': usuario.nome,
          'email': usuario.email,
          'senha': usuario.senha,
          'telefone': usuario.telefone,
          'isAdmin': usuario.isAdmin,
        },
      );

      return response.statusCode == 200
          ? '${usuario.isAdmin ? 'Administrador' : 'Associado'} atualizado com sucesso!'
          : 'Erro ao atualizar ${usuario.isAdmin ? 'administrador' : 'associado'}.';
    } on DioException catch (e) {
      return ErroException.tratarErro(e);
    }
  }

  Future<String?> atualizarUsuarioParcial({
    required Usuario usuario,
    String? nome,
    String? email,
    String? senha,
    String? telefone,
  }) async {
    try {
      int id;
      if (usuario is Administrador) {
        id = usuario.idAdministrador;
      } else if (usuario is Associado) {
        id = usuario.idAssociado;
      } else {
        return 'Tipo de usuário desconhecido.';
      }

      final Map<String, dynamic> data = {};
      if (nome != null) data['nome'] = nome;
      if (email != null) data['email'] = email;
      if (senha != null) data['senha'] = senha;
      if (telefone != null) data['telefone'] = telefone;

      final response = await ApiCliente.dio.patch('/usuario/$id', data: data);

      return response.statusCode == 200
          ? '${usuario.isAdmin ? 'Administrador' : 'Associado'} atualizado com sucesso!'
          : 'Erro ao atualizar ${usuario.isAdmin ? 'administrador' : 'associado'} parcialmente.';
    } on DioException catch (e) {
      return ErroException.tratarErro(e);
    }
  }

  Future<String?> deletar(int id) async {
    try {
      final response = await ApiCliente.dio.patch(
        'usuario/$id',
        data: {
          'deletado': true,
        },
      );

      return response.statusCode == 200
          ? 'Administrador deletado com sucesso!'
          : 'Erro ao deletar administrador.';
      } on DioException catch (e) {
      return ErroException.tratarErro(e);
    }
  }
}
