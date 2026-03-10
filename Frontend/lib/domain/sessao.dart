import 'package:play_now/domain/usuario.dart';

class Sessao {
  static Usuario? usuarioLogado;

  static bool get isAdmin => usuarioLogado?.isAdmin ?? false;

  static void login(Usuario usuario) {
    usuarioLogado = usuario;
  }

  static void logout() {
    usuarioLogado = null;
  }
}
