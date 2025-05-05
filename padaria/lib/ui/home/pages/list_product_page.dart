import 'package:flutter/material.dart';
import '../../../core/services/product_service.dart';
import '../../../data/models/product_model.dart';

class ListProductPage extends StatefulWidget {
  const ListProductPage({super.key});

  @override
  State<ListProductPage> createState() => _ListProductPageState();
}

class _ListProductPageState extends State<ListProductPage> {
  final ProductService _productService = ProductService();
  late Future<List<ProductModel>> _productFuture;
  @override
  void initState() {
    super.initState();
    _productFuture = _productService.listProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Produtos"),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.brown,
            ));
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Erro: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Nenhum produto encontrado."),
            );
          }

          final products = snapshot.data;
          return ListView.builder(
              itemCount: products?.length,
              itemBuilder: (context, index) {
                final product = products?[index];
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
                        product!.descricao,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      subtitle: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                              "R\$ ${product.valor.toStringAsFixed(2)} - Estoque: ${product.estoque}"),
                        ],
                      ),
                      trailing: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            color:
                                product.status == 1 ? Colors.green : Colors.red,
                            shape: BoxShape.circle),
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
