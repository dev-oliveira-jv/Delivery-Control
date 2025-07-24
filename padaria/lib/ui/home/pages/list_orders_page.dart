import 'package:padaria/core/enum/create_order_mode.dart';

import 'create_order_page.dart';
import '../../../core/services/orders_service.dart';
import '../../../data/models/orders_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListOrdersPage extends StatefulWidget {
  const ListOrdersPage({super.key});

  @override
  State<ListOrdersPage> createState() => _ListOrdersPageState();
}

class _ListOrdersPageState extends State<ListOrdersPage> {
  final OrdersService _ordersService = OrdersService();
  late Future<List<OrdersModel>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _ordersService.listOrders();
  }

  void _refreshList() {
    super.initState();
    _ordersFuture = _ordersService.listOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Selecione a venda"),
      ),
      body: FutureBuilder<List<OrdersModel>>(
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.brown,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child:
                    Text("Nenhuma venda encontrada. erro: ${snapshot.error}"),
              );
            }

            final orders = snapshot.data;
            return ListView.builder(
              itemCount: orders?.length,
              itemBuilder: (context, index) {
                final order = orders?[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        title: Text(
                          "Pedido #${order!.numVenda}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Cliente: ${order.userName}"),
                            Text(
                                "Total: R\$ ${order.valorTotal.toStringAsFixed(2)}"),
                            Text(
                                "Data: ${DateFormat('dd/MM/yyyy - HH:mm').format(order.dataHora)}")
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => CreateOrderPage(
                                        mode: CreateOrderMode.edicao,
                                        isAdmin: true,
                                        userId: order.userId,
                                        userName: order.userName,
                                        objectId: order.objectId,
                                        status: order.status,
                                        ordes: order.items,
                                      )));
                        }),
                  ),
                );
              },
            );
          }),
    );
  }
}
