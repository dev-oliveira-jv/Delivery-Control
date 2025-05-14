import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../../core/network/api_products.dart';

class ProductRepository {
  Future<ProductModel> createProduct(ProductModel product) async {
    final response = await ApiProducts.post("/create-product", {
      'descricao': product.descricao,
      'valor': product.valor,
      'status': product.estoque,
      'grupoId': product.grupoId,
      'estoque': product.status,
    });
    return ProductModel.fromJson(response);
  }

  Future<List<ProductModel>> listProduct() async {
    final response = await ApiProducts.postList("/list-products", {});
    return response.map((item) => ProductModel.fromJson(item)).toList();
  }

  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await ApiProducts.post('/update-product', {
      'objectId': product.objectId,
      'descricao': product.descricao,
      'valor': product.valor,
      'status': product.estoque,
      'grupoId': product.grupoId,
      'estoque': product.status,
    });
    return ProductModel.fromJson(response);
  }

  Future<void> deleteProduct(String objectId) async {
    await ApiProducts.post("/delete-product", {
      'objectId': objectId,
    });
  }

  Future<List<Map<String, dynamic>>> listGrupo() async {
    final result = await ApiProducts.getList("/list-groups");
    return List<Map<String, dynamic>>.from(result);
  }

  Future<ProductModel> getProductById(String objectId) async {
    final response = await ApiProducts.post("/get-product", {
      'objectId': objectId,
    });
    return ProductModel.fromJson(response);
  }
}
