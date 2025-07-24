enum OrderStatus { criado, entregue, pago }

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.criado:
        return 'Criado';
      case OrderStatus.entregue:
        return 'Entregue';
      case OrderStatus.pago:
        return 'Pago';
    }
  }

  int get value => index;

  static OrderStatus fromInt(int value) {
    return OrderStatus.values[value];
  }
}
