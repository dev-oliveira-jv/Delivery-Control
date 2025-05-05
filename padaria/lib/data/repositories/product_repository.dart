import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../../core/network/api_products.dart';

class ProductRepository {
  Future<ProductModel> createProduct(ProductModel product) async {
    final response = await ApiProducts.post("/create-product", {
      'descricao': product.descricao,
      'valor': product.valor,
      'status': product.status,
      'grupoId': product.grupoId,
      'estoque': product.estoque,
    });
    return ProductModel.fromJson(response);
  }

  Future<List<ProductModel>> listProduct() async {
    final response = await ApiProducts.postList("/list-products", {});
    return response.map((item) => ProductModel.fromJson(item)).toList();
  }

  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await ApiProducts.post('/update-products', {
      'objectId': product.objectId,
      'descricao': product.descricao,
      'valor': product.valor,
      'status': product.status,
      'grupoId': product.grupoId,
      'estoque': product.estoque,
    });
    return ProductModel.fromJson(response);
  }

  Future<void> deleteProduct(String objesctId) async {
    await ApiProducts.post("/delete-product", {
      'objectId': objesctId,
    });
  }
}
