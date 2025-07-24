class ProductModel {
  final String? objectId;
  final String descricao;
  final double valor;
  final int? status;
  final String? grupoId;
  final int? estoque;

  ProductModel({
    this.objectId,
    required this.descricao,
    required this.valor,
    this.status,
    this.grupoId,
    this.estoque,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      objectId: json['objectId'],
      descricao: json['descricao'],
      valor: json['valor']?.toDouble() ?? 0.0,
      status: json['status'],
      grupoId: json['grupo']?['objectId'] ?? '',
      estoque: json['estoque'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'objectId': objectId,
      'descricao': descricao,
      'valor': valor,
      'status': status,
      'grupoId': grupoId,
      'estoque': estoque,
    };
  }
}
