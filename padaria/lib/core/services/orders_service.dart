import '../../data/models/orders_model.dart';
import '../../data/repositories/orders_repository.dart';

class OrdersService {
  final OrdersRepository _ordersRepository = OrdersRepository();

  Future<OrdersModel> createOrder(
      String userId,
      String userName,
      List<OrderItem> items,
      double valorTotal,
      String? endereco,
      String? telefone,
      String? observacao,
      int numVenda) async {
    final order = OrdersModel(
        userId: userId,
        userName: userName,
        items: items,
        valorTotal: valorTotal,
        status: 0,
        dataHora: DateTime.now(),
        observacao: observacao,
        numVenda: numVenda);
    return await _ordersRepository.createOrder(order);
  }

  Future<List<OrdersModel>> listOrders() async {
    return await _ordersRepository.listOrders();
  }

  Future<List<OrdersModel>> listOrdersByUser(String userId) async {
    return await _ordersRepository.listOrdersByUser(userId);
  }

  Future<OrdersModel> updateOrdersStatus(String objectId, int status) async {
    return await _ordersRepository.updateOrderStatus(objectId, status);
  }

  Future<void> deleteOrder(String objectId) async {
    await _ordersRepository.deleteOrder(objectId);
  }
}
