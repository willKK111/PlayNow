import 'package:flutter/material.dart';
import 'package:play_now/domain/usuario.dart';

class UsuarioProvider with ChangeNotifier {
  List<Usuario> _usuarios = [];

  List<Usuario> get usuarios => _usuarios;

  void atualizarUsuario(Usuario usuarioAtualizado) {
    final index = _usuarios.indexWhere((u) => u.id == usuarioAtualizado.id);
    if (index != -1) {
      _usuarios[index] = usuarioAtualizado;
      notifyListeners();
    }
  }

  void setUsuarios(List<Usuario> lista) {
    _usuarios = lista;
    notifyListeners();
  }
}
