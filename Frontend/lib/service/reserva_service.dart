import 'package:dio/dio.dart';
import 'package:play_now/domain/reserva.dart';
import 'package:play_now/functions/tratar_erro.dart';
import 'api_cliente.dart';

class ReservaService {
  Future<String?> adicionar(Reserva reserva) async {
    try {
      final response = await ApiCliente.dio.post('/Reserva', data: reserva.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data ?? 'Reserva criada com sucesso!';
      }
    } on DioException catch (e) {
      return ErroException.tratarErro(e);
    } catch (e) {
      return 'Erro inesperado';
    }
  }

  Future<String?> deletar(int id) async {
    try {
      final response = await ApiCliente.dio.delete('/Reserva/$id');
      if (response.statusCode == 200) {
        return response.data ?? 'Reserva deletada com sucesso!';
      }
    } on DioException catch (e) {
      return ErroException.tratarErro(e);
    } catch (e) {
      return 'Erro inesperado';
    }
  }

  Future<List<Reserva>?> buscarTodas() async {
    try {
      final response = await ApiCliente.dio.get('/Reserva/selecionarTodas');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((reservaJson) => Reserva.fromJson(reservaJson))
            .toList();
      }
    } on DioException catch (e) {
      throw Exception(ErroException.tratarErro(e));
    }
  }

  Future<Map<String, List<String>>> buscarHorariosDisponiveis(DateTime data) async {
    try {
      final dataFormatada = data.toIso8601String();
      final response = await ApiCliente.dio.get('/Reserva/horarios-disponiveis?data=$dataFormatada');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        return data.map((key, value) {
          return MapEntry(key, List<String>.from(value));
        });
      }
      return {};
    } on DioException catch (e) {
      throw Exception(ErroException.tratarErro(e));
    }
  }

  Future<Reserva?> buscarPorId(int id) async {
    try {
      final response = await ApiCliente.dio.get('/Reserva/$id');
      if (response.statusCode == 200) {
        return Reserva.fromJson(response.data);
      }
    } on DioException catch (e) {
      throw Exception(ErroException.tratarErro(e));
    }
  }
}