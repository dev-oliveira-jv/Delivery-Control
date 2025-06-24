class OrdersModel {
  final String? objectId;
  final String? userId;
  final String? userName;
  final List<OrderItem> items;
  final double valorTotal;
  final int status;
  final String? endereco;
  final String? telefone;
  final DateTime dataHora;
  final String? observacao;

  OrdersModel(
      {this.objectId,
      required this.userId,
      required this.userName,
      required this.items,
      required this.valorTotal,
      required this.status,
      this.endereco,
      this.telefone,
      required this.dataHora,
      this.observacao});

  factory OrdersModel.fromJson(Map<String, dynamic> json) {
    return OrdersModel(
      objectId: json['objectId'],
      userId: json['userId'],
      userName: json['userName'],
      items: (json['items'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      valorTotal: json['valorTotal']?.toDouble() ?? 0.0,
      status: json['status'],
      endereco: json['endereco'],
      telefone: json['telefone'],
      dataHora: json['dataHora'] != null
          ? DateTime.parse(json['dataHora'])
          : DateTime.now(),
      observacao: json['observacao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'objectId': objectId,
      'cliente': userId,
      'userName': userName,
      'items': items.map((item) => item.toJson()).toList(),
      'valorTotalFront': valorTotal,
      'status': status,
      'dataHora': dataHora.toIso8601String(),
      'observacao': observacao,
    };
  }
}

class OrderItem {
  final String? productId;
  final String? descricao;
  final int? quantidade;
  final double valorUnitario;
  final double valorTotal;

  OrderItem(
      {required this.productId,
      required this.descricao,
      required this.quantidade,
      required this.valorUnitario,
      required this.valorTotal});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
        productId: json['productId'],
        descricao: json['descricao'],
        quantidade: json['quantidade'],
        valorUnitario: json['valorUnitario']?.toDouble() ?? 0.0,
        valorTotal: json['valorTotal']?.toDouble() ?? 0.0);
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'descricao': descricao,
      'quantidade': quantidade,
      'valorUnitario': valorUnitario,
      'valorTotal': valorTotal,
    };
  }

  OrderItem copyWith({
    String? productId,
    String? descricao,
    int? quantidade,
    double? valorUnitario,
    double? valorTotal,
  }) {
    return OrderItem(
      productId: productId ?? this.productId,
      descricao: descricao ?? this.descricao,
      quantidade: quantidade ?? this.quantidade,
      valorUnitario: valorUnitario ?? this.valorUnitario,
      valorTotal: valorTotal ?? this.valorTotal,
    );
  }
}
