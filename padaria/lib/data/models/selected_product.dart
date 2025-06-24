import '../models/product_model.dart';

class SelectedProduct {
  final ProductModel product;
  int quantidade;

  SelectedProduct({required this.product, this.quantidade = 1});
}
