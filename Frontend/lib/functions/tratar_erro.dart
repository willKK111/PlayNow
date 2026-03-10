import 'package:dio/dio.dart';

class ErroException {
  static String tratarErro(DioException e) {
    if (e.response != null) {
      final status = e.response!.statusCode;
      final data = e.response!.data;

      if (status == 400) {
        return data is String ? data : 'Requisição inválida';
      } else if (status == 404) {
        return data is String ? data : 'Recurso não encontrado';
      } else if (status == 500) {
        return 'Erro interno do servidor';
      } else {
        return 'Erro desconhecido: ${e.message}';
      }
    } else {
      return 'Erro de conexão: ${e.message}';
    }
  }
}
