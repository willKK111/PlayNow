import 'package:dio/dio.dart';
import 'package:play_now/domain/quadra.dart';
import 'package:play_now/functions/tratar_erro.dart';
import 'api_cliente.dart';

class QuadraService {
  Future<String?> adicionar(Quadra quadra) async {
    try {
      final response = await ApiCliente.dio.post(
          '/Quadra', data: quadra.toJson());
      if (response.statusCode == 200) {
        return response.data ?? 'Quadra adicionada';
      }
    } on DioException catch (e) {
      return ErroException.tratarErro(e);
    } catch (e) {
      return 'Erro inesperado';
    }
  }

  Future<String?> atualizar(Quadra quadra) async {
    try {
      final response = await ApiCliente.dio.put(
          '/Quadra/${quadra.idQuadra}', data: quadra.toJson());
      if (response.statusCode == 200) {
        return response.data ?? 'Quadra atualizada';
      }
    } on DioException catch (e) {
      return ErroException.tratarErro(e);
    }
  }

  Future<String?> deletar(int id) async {
    try {
      final response = await ApiCliente.dio.delete('/Quadra/$id');
      if (response.statusCode == 200) {
        return response.data ?? 'Quadra deletada';
      }
    } on DioException catch (e) {
      return ErroException.tratarErro(e);
    }
  }

  Future<Quadra?> buscarPorId(int id) async {
    try {
      final response = await ApiCliente.dio.get('/Quadra/$id');
      if (response.statusCode == 200) {
        return Quadra.fromJson(response.data);
      }
    } on DioException catch (e) {
      throw Exception(ErroException.tratarErro(e));
    }
  }

  Future<List<Quadra>> buscarTodas() async {
    try {
      final response = await ApiCliente.dio.get('/Quadra/selecionarTodas');
      print('[QuadraService] Resposta: ${response.data}');

      if (response.statusCode == 200) {
        final quadras = (response.data as List)
            .map((e) => Quadra.fromJson(e))
            .toList();
        print('[QuadraService] Quadras convertidas: ${quadras.map((q) => q.nome)
            .toList()}');
        return quadras;
      } else {
        return [];
      }
    } catch (e) {
      print('[QuadraService] Erro ao buscar quadras: $e');
      return [];
    }
  }
}
