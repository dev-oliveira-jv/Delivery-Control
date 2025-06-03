import 'package:flutter/material.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/orders_model.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/repositories/orders_repository.dart';
import '../../../data/models/user_model.dart';
import '../../widgets/cart_widget.dart';

class CreateOrderPage extends StatefulWidget {
  final bool isAdmin;
  final String userId;
  final String userName;

  const CreateOrderPage({
    super.key,
    required this.isAdmin,
    required this.userId,
    required this.userName,
  });

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  List<ProductModel> products = [];
  List<OrderItem> cartItems = [];
  double total = 0.0;
  late UserModel user;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController observacaoController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProducts();
    if (!widget.isAdmin) {
      nomeController.text = widget.userName;
      user = UserModel(
          objectId: widget.userId,
          username: widget.userName,
          email: '',
          sessionToken: '',
          privelegeId: 3,
          privelege: {});
    }
  }

  Future<void> fetchProducts() async {
    products = await ProductRepository().listProduct();
    setState(() {});
  }

  void addToCart(ProductModel product) {
    final index =
        cartItems.indexWhere((item) => item.productId == product.objectId);
    setState(() {
      if (index != -1) {
        cartItems[index] = OrderItem(
            productId: product.objectId!,
            descricao: product.descricao,
            quantidade: cartItems[index].quantidade! + 1,
            valorUnitario: product.valor,
            valorTotal: (cartItems[index].quantidade! + 1) * product.valor);
      } else {
        cartItems.add(OrderItem(
            productId: product.objectId!,
            descricao: product.descricao,
            quantidade: 1,
            valorUnitario: product.valor,
            valorTotal: product.valor));
      }
      calculateTotal();
    });
  }

  void removeFromCart(String? productId) {
    setState(() {
      final index = cartItems.indexWhere((item) => item.productId == productId);
      if (index != -1) {
        if (cartItems[index].quantidade! > 1) {
          final item = cartItems[index];
          cartItems[index] = OrderItem(
            productId: item.productId,
            descricao: item.descricao,
            quantidade: item.quantidade! - 1,
            valorUnitario: item.valorUnitario,
            valorTotal: (item.quantidade! - 1) * item.valorUnitario,
          );
          calculateTotal();
        } else {
          cartItems.removeAt(index);
        }
        calculateTotal();
      }
    });
  }

  void calculateTotal() {
    total = cartItems.fold(0.0, (sum, item) => sum + item.valorTotal);
    setState(() {});
  }

  double get totalCartValue =>
      cartItems.fold(0.0, (sum, item) => sum + item.valorTotal);

  Future<void> finalizeOrder() async {
    if (!_formKey.currentState!.validate() || cartItems.isEmpty) return;
    final newOrder = OrdersModel(
        userId: widget.isAdmin ? user.objectId : widget.userId,
        userName: widget.isAdmin ? nomeController.text : widget.userName,
        items: cartItems,
        valorTotal: total,
        status: 0,
        dataHora: DateTime.now(),
        endereco: enderecoController.text,
        telefone: telefoneController.text,
        observacao: observacaoController.text);
    await OrdersRepository().createOrder(newOrder);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pedido criado com sucesso!")));

    setState(() {
      cartItems.clear();
      total = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Novo pedido"),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (widget.isAdmin)
                            TextFormField(
                              controller: nomeController,
                              decoration: const InputDecoration(
                                  labelText: 'Nome do cliente'),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Informe o nome'
                                      : null,
                            ),
                          TextFormField(
                            controller: telefoneController,
                            decoration:
                                const InputDecoration(labelText: 'Telefone'),
                          ),
                          TextFormField(
                            controller: enderecoController,
                            decoration:
                                const InputDecoration(labelText: 'Endereço'),
                          ),
                          TextFormField(
                            controller: observacaoController,
                            decoration:
                                const InputDecoration(labelText: 'Observação'),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Produtos',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  ...products.map((product) {
                    final item = cartItems.firstWhere(
                        (e) => e.productId == product.objectId,
                        orElse: () => OrderItem(
                            productId: product.objectId!,
                            descricao: product.descricao,
                            quantidade: 0,
                            valorUnitario: product.valor,
                            valorTotal: 0.0));
                    return ListTile(
                      title: Text(product.descricao),
                      subtitle: Text("R\$ ${product.valor.toStringAsFixed(2)}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () => removeFromCart(product.objectId),
                              icon: const Icon(Icons.remove)),
                          Text("${item.quantidade}"),
                          IconButton(
                              onPressed: () => addToCart(product),
                              icon: Icon(Icons.add)),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(
                    height: 10,
                  ),
                  if (cartItems.isNotEmpty) CartWidget(cart: cartItems),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: cartItems.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                    onPressed: finalizeOrder,
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50)),
                    child: Text(
                        'Finalizar Pedido - R\$ ${totalCartValue.toStringAsFixed(2)}')),
              )
            : SizedBox.shrink());
  }
}
