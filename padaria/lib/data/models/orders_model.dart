class OrdersModel {
  final String? objectId;
  final int? numVenda;
  final String? userId;
  final String? userName;
  final List<OrderItem> items;
  final double valorTotal;
  final int status;
  final DateTime dataHora;
  final String? observacao;

  OrdersModel(
      {this.objectId,
      required this.numVenda,
      required this.userId,
      required this.userName,
      required this.items,
      required this.valorTotal,
      required this.status,
      required this.dataHora,
      this.observacao});

  factory OrdersModel.fromJson(Map<String, dynamic> json) {
    final cliente = json['cliente'] ?? {};
    final data = json['dataHora'];
    final itensJson = (json['itens'] as List<dynamic>?) ?? [];
    return OrdersModel(
      objectId: json['objectId'],
      numVenda: json['numVenda'] is int
          ? json['numVenda']
          : int.tryParse(json['numVenda'].toString()) ?? 0,
      userId: cliente['objectId'],
      userName: cliente['username'],
      items: itensJson.map((item) => OrderItem.fromJson(item)).toList(),
      valorTotal: json['valor_total']?.toDouble() ?? 0.0,
      status: json['status'] is int
          ? json['status']
          : int.tryParse(json['status'].toString()) ?? 0,
      dataHora: data != null && data['iso'] != null
          ? DateTime.parse(data['iso'])
          : DateTime.now(),
      observacao: json['observacao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cliente': userId,
      'username': userName,
      'objectId': objectId,
      'itens': items.map((item) => item.toJson()).toList(),
      'valorTotalfront': valorTotal,
      'status': status,
      'data': dataHora.toIso8601String(),
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
