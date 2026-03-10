import 'package:dio/dio.dart';
import 'package:play_now/domain/administrador.dart';
import 'package:play_now/domain/associado.dart';
import 'package:play_now/domain/sessao.dart';
import 'package:play_now/domain/usuario.dart';
import 'package:play_now/service/api_cliente.dart';

class AutenticacaoService {
  Future<Usuario> autenticar(String email, String senha) async {
    try {
      final response = await ApiCliente.dio.post('/autenticacao', data: {
        'email': email,
        'senha': senha,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        final usuarioJson = data['usuario'];
        final isAdmin = data['isAdmin'] ?? false;

        Usuario usuario;
        if (isAdmin) {
          usuario = Administrador.fromJson(usuarioJson);
        } else {
          usuario = Associado.fromJson(usuarioJson);
        }

        Sessao.login(usuario); // ← Aqui salva o usuário logado
        return usuario;
      } else {
        throw Exception('Erro inesperado. Código ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.data['erro'] != null) {
        throw Exception(e.response?.data['erro']);
      }
      throw Exception('Erro de conexão com o servidor');
    }
  }
}
