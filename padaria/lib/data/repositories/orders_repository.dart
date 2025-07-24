import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/orders_model.dart';
import '../../core/network/api_ordes.dart';

class OrdersRepository {
  Future<OrdersModel> createOrder(OrdersModel order) async {
    final response = await ApiOrdes.post("/create-order", order.toJson());
    return OrdersModel.fromJson(response);
  }

  Future<List<OrdersModel>> listOrders() async {
    final response = await ApiOrdes.postList("/list-orders", {});
    return response.map((item) => OrdersModel.fromJson(item)).toList();
  }

  Future<List<OrdersModel>> listOrdersByUser(String userId) async {
    final response = await ApiOrdes.postList("/list-orders-by-user", {
      'userId': userId,
    });
    return response.map((item) => OrdersModel.fromJson(item)).toList();
  }

  Future<OrdersModel> updateOrderStatus(String? objectId, int? status) async {
    final response = await ApiOrdes.post("/update-order-status", {
      'objectId': objectId,
      'status': status,
    });
    return OrdersModel.fromJson(response);
  }

  Future<void> deleteOrder(String objectId) async {
    await ApiOrdes.post("/delete-order", {'objectId': objectId});
  }

  Future<int> getOrderNumber() async {
    final response = await ApiOrdes.post("/get-order-number", {});
    return response['numVenda'];
  }
}
