class Categoria {
  final int? idCategoria;
  final String nome;

  Categoria({
    this.idCategoria,
    required this.nome,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      idCategoria: json['idCategoria'],
      nome: json['nome'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Categoria &&
              runtimeType == other.runtimeType &&
              idCategoria == other.idCategoria;

  @override
  int get hashCode => idCategoria.hashCode;

  @override
  String toString() => nome;
}
