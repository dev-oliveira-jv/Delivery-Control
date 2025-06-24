import 'package:flutter/material.dart';
import 'package:padaria/ui/widgets/select_user_page.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/orders_model.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/repositories/orders_repository.dart';
import '../../../data/models/user_model.dart';
import '../../widgets/cart_widget.dart';
import '../../home/pages/list_product_page.dart';
import '../../../core/enum/list_producto_page_mode.dart';
import '../../../data/models/selected_product.dart';

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
  UserModel? selectedClient;
  List<SelectedProduct> selectedProducts = [];
  List<ProductModel> products = [];
  List<OrderItem> cartItems = [];
  double total = 0.0;
  late UserModel user;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
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
        userId: widget.isAdmin ? selectedClient?.objectId : widget.userId,
        userName: widget.isAdmin ? selectedClient?.username : widget.userName,
        items: cartItems,
        valorTotal: total,
        status: 0,
        dataHora: DateTime.now(),
        observacao: observacaoController.text);
    await OrdersRepository().createOrder(newOrder);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pedido criado com sucesso!")));

    setState(() {
      cartItems.clear();
      selectedProducts.clear();
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
                          if (widget.isAdmin) ...[
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton.icon(
                                icon: Icon(Icons.person_search),
                                onPressed: () async {
                                  final user = await Navigator.push<UserModel>(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => SelectUserPage()));
                                  if (user != null) {
                                    setState(() {
                                      selectedClient = user;
                                      nomeController.text = user.username ?? "";
                                    });
                                  }
                                },
                                label: Text(selectedClient == Null
                                    ? "Selecionar Cliente"
                                    : selectedClient!.username!))
                          ],
                          TextFormField(
                            controller: observacaoController,
                            decoration:
                                const InputDecoration(labelText: 'Observação'),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Produtos',
                                style: TextStyle(fontSize: 18),
                              ),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const ListProductPage(
                                        mode: ListProductMode.selecao,
                                      ),
                                    ),
                                  ) as SelectedProduct?;
                                  if (result != null) {
                                    setState(() {
                                      selectedProducts.add(result);

                                      final index = cartItems.indexWhere(
                                          (item) =>
                                              item.productId ==
                                              result.product.objectId);
                                      if (index != -1) {
                                        cartItems[index] =
                                            cartItems[index].copyWith(
                                          quantidade: result.quantidade,
                                          valorTotal: result.quantidade *
                                              result.product.valor,
                                        );
                                      } else {
                                        cartItems.add(OrderItem(
                                            productId: result.product.objectId!,
                                            descricao: result.product.descricao,
                                            quantidade: result.quantidade,
                                            valorUnitario: result.product.valor,
                                            valorTotal: result.quantidade *
                                                result.product.valor));
                                      }

                                      calculateTotal();
                                    });
                                  }
                                },
                                icon: const Icon(Icons.shopping_basket),
                                label: const Text('Selecionar Produtos'),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.brown),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (selectedProducts.isNotEmpty)
                            Column(
                              children:
                                  selectedProducts.take(4).map((selected) {
                                return Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: ListTile(
                                    title: Text(selected.product.descricao),
                                    subtitle: Text(
                                        "R\$ ${selected.product.valor.toStringAsFixed(2)}"),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () {
                                            setState(() {
                                              if (selected.quantidade > 1) {
                                                selected.quantidade--;
                                                removeFromCart(
                                                    selected.product.objectId);
                                                calculateTotal();
                                              } else {
                                                removeFromCart(
                                                    selected.product.objectId);
                                                selectedProducts.removeWhere(
                                                    (item) =>
                                                        item.product.objectId ==
                                                        selected
                                                            .product.objectId);
                                                calculateTotal();
                                              }
                                            });
                                          },
                                        ),
                                        Text('${selected.quantidade}'),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () {
                                            setState(() {
                                              selected.quantidade++;
                                              addToCart(selected.product);
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            )
                        ],
                      )),
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
