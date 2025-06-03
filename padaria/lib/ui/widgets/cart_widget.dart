import 'package:flutter/material.dart';
import '../../data/models/orders_model.dart';

class CartWidget extends StatelessWidget {
  final List<OrderItem> cart;

  const CartWidget({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    if (cart.isEmpty) return SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Carrinho',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ...cart.map((item) => ListTile(
                title: Text(item.descricao!),
                subtitle: Text(
                    "${item.quantidade}X R\$ ${item.valorUnitario.toStringAsFixed(2)}"),
                trailing: Text("R\$ ${item.valorTotal.toStringAsFixed(2)}"),
              ))
        ],
      ),
    );
  }
}
