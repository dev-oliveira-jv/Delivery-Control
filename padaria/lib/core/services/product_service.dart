import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

class ProductService {
  final ProductRepository _productRepository = ProductRepository();

  Future<ProductModel> createProduct(String descricao, double valor, int status,
      String grupoId, int estoque) async {
    final product = ProductModel(
        descricao: descricao,
        valor: valor,
        status: status,
        grupoId: grupoId,
        estoque: estoque);
    return await _productRepository.createProduct(product);
  }

  Future<List<ProductModel>> listProduct() async {
    return await _productRepository.listProduct();
  }

  Future<ProductModel> updateProduct(String objectId, String descricao,
      double valor, int status, String grupoId, int estoque) async {
    final product = ProductModel(
        objectId: objectId,
        descricao: descricao,
        valor: valor,
        status: status,
        grupoId: grupoId,
        estoque: estoque);
    return await _productRepository.updateProduct(product);
  }

  Future<void> deleteProduct(String objectId) async {
    await _productRepository.deleteProduct(objectId);
  }
}
