import 'package:dio/dio.dart';
import 'package:play_now/domain/categoria.dart';
import 'package:play_now/functions/tratar_erro.dart';
import 'api_cliente.dart';

class CategoriaService {
  Future<String?> adicionar(Categoria categoria) async {
    try {
      final response = await ApiCliente.dio.post('/categoria', data: categoria.toJson());
      if (response.statusCode == 200) {
        return response.data ?? 'Categoria adicionada';
      }
    } on DioException catch (e) {
      return ErroException.tratarErro(e);
    } catch (e) {
      return 'Erro inesperado';
    }
  }

  Future<String?> atualizar(Categoria categoria) async {
    try {
      final response = await ApiCliente.dio.put('/categoria/${categoria.idCategoria}', data: categoria.toJson());
      if (response.statusCode == 200) {
        return response.data ?? 'Categoria atualizada';
      }
    } on DioException catch (e) {
      return ErroException.tratarErro(e);
    }
  }

  Future<String?> deletar(int id) async {
    try {
      final response = await ApiCliente.dio.delete('/categoria/$id');
      if(response.statusCode == 200) {
        return response.data ?? 'Categoria deletada';
      }
    } on DioException catch (e) {
      return ErroException.tratarErro(e);
    }
  }

  Future<Categoria?> buscarPorId(int id) async {
    try {
      final response = await ApiCliente.dio.get('/categoria/$id');
      if(response.statusCode == 200) {
        return Categoria.fromJson(response.data);
      }
    } on DioException catch (e) {
      throw Exception(ErroException.tratarErro(e));
    }
  }

  Future<List<Categoria>?> buscarTodas() async {
    try {
      final response = await ApiCliente.dio.get('/categoria/selecionarTodas');
      if(response.statusCode == 200) {
        return (response.data as List).map((e) => Categoria.fromJson(e)).toList();
      }
    } on DioException catch (e) {
      throw Exception(ErroException.tratarErro(e));
    }
  }

}
