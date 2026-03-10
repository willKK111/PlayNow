import 'package:dio/dio.dart';

class ApiCliente {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://testeclubeesportivo.somee.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  )..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        print('[Dio] Enviando requisição: ${options.method} ${options.uri}');
        print('[Dio] Dados: ${options.data}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('[Dio] Resposta recebida: ${response.statusCode} ${response.requestOptions.uri}');
        print('[Dio] Dados da resposta: ${response.data}');
        return handler.next(response);
      },
      onError: (DioError e, handler) {
        print('[Dio] Erro na requisição: ${e.response?.statusCode} ${e.requestOptions.uri}');
        print('[Dio] Mensagem de erro: ${e.message}');
        return handler.next(e);
      },
    ),
  );
}

