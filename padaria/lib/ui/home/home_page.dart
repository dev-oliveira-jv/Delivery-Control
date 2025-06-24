import 'package:flutter/material.dart';
import 'package:padaria/data/models/user_model.dart';
import 'package:padaria/ui/home/pages/create_order_page.dart';
import 'pages/home_content.dart';
import 'pages/create_product_page.dart';
import 'pages/perfil_page.dart';
import 'pages/list_product_page.dart';

class HomePage extends StatefulWidget {
  final int privelegeId;
  final UserModel userModel;
  const HomePage(
      {required this.privelegeId, super.key, required this.userModel});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Widget> _buildPages(UserModel user) {
    switch (user.privelegeId) {
      case 1: // Administrador
        return [
          HomeContent(),
          ListProductPage(),
          PerfilPage(),
          CreateProductPage(),
          CreateOrderPage(
              isAdmin: true, userId: user.objectId!, userName: user.username!)
        ];
      case 2: // Entregador
        return [
          HomeContent(),
          PerfilPage(),
          CreateOrderPage(
              isAdmin: true, userId: user.objectId!, userName: user.username!)
        ];
      case 3: // Usuário
        return [
          HomeContent(),
          PerfilPage(),
          ListProductPage(),
          CreateProductPage(),
          CreateOrderPage(
              isAdmin: false, userId: user.objectId!, userName: user.username!)
        ];
    }
    throw Exception('Privilegio não encontrado');
  }

  List<BottomNavigationBarItem> _buildNavItems(int privilegeId) {
    switch (privilegeId) {
      case 1: // Administrador
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Cadastro'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Usuário'),
          BottomNavigationBarItem(
              icon: Icon(Icons.app_registration), label: 'Produtos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), label: 'Pedidos')
        ];
      case 2: // Entregador
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Usuário'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), label: 'Pedidos')
        ];
      case 3: //Usuário
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Usuário'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list), label: 'Lista de Produtos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.app_registration), label: 'Produto'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), label: 'Pedidos')
        ];
      default:
        throw Exception("Privilégio não encontrado");
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = _buildPages(widget.userModel);
    final items = _buildNavItems(widget.userModel.privelegeId);
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() {
                _currentIndex = index;
              }),
          selectedItemColor: Colors.brown,
          unselectedItemColor: Colors.grey,
          items: items),
    );
  }
}
