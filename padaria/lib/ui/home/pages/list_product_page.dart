import 'package:flutter/material.dart';
import 'package:padaria/ui/home/pages/create_product_page.dart';
import '../../../core/services/product_service.dart';
import '../../../data/models/product_model.dart';
import '../../../core/enum/list_producto_page_mode.dart';

class ListProductPage extends StatefulWidget {
  const ListProductPage({Key? key, this.mode = ListProductMode.edicao})
      : super(key: key);
  final ListProductMode mode;

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

  void _refreshList() {
    setState(() {
      _productFuture = _productService.listProduct();
    });
  }

  void _handleProductTap(ProductModel produto) async {
    if (widget.mode == ListProductMode.selecao) {
      final produtoSelecionado = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => CreateProductPage(
                  productId: produto.objectId, mode: ListProductMode.selecao)));
      if (produtoSelecionado != null) {
        Navigator.pop(context, produtoSelecionado);
      }
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => CreateProductPage(
                  productId: produto.objectId, mode: ListProductMode.edicao)));
      _refreshList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mode == ListProductMode.selecao
            ? "Produtos"
            : "Selecione um produto"),
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
                      onTap: () => _handleProductTap(product),
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
