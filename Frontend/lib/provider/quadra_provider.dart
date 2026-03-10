import 'package:flutter/cupertino.dart';
import 'package:play_now/domain/quadra.dart';

class QuadraProvider extends ChangeNotifier {
  Quadra? _quadra;

  Quadra? get quadra => _quadra;

  void setQuadra(Quadra nova) {
    _quadra = nova;
    notifyListeners();
  }

  void atualizarQuadra(Quadra quadraAtualizada) {
    if (_quadra != null && _quadra!.idQuadra == quadraAtualizada.idQuadra) {
      _quadra = quadraAtualizada;
      notifyListeners();
    }
  }
}
