import 'categoria.dart';

class Quadra {
  int idQuadra;
  String nome;
  int numero;
  int maximoPessoas;
  Categoria categoria;

  Quadra({
    required this.idQuadra,
    required this.nome,
    required this.numero,
    required this.maximoPessoas,
    required this.categoria,
  });

  factory Quadra.fromJson(Map<String, dynamic> json) => Quadra(
    idQuadra: json['idQuadra'],
    nome: json['nome'],
    numero: json['numero'],
    maximoPessoas: json['maximoPessoas'],
    categoria: Categoria.fromJson(json['categoria']),
  );

  Map<String, dynamic> toJson() => {
    'numero': numero,
    'nome': nome,
    'maximoPessoas': maximoPessoas,
    'idCategoria': categoria.idCategoria,
  };
}
