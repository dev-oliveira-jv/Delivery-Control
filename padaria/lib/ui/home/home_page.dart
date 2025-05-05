import 'package:flutter/material.dart';
import 'pages/home_content.dart';
import 'pages/cadastro_page.dart';
import 'pages/perfil_page.dart';
import 'pages/list_product_page.dart';

class HomePage extends StatefulWidget {
  final int privilegeId;
  const HomePage({required this.privilegeId, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Widget> _buildPages(int privilegeId) {
    switch (privilegeId) {
      case 1: // Administrador
        return const [HomeContent(), CadastroPage(), PerfilPage()];
      case 2: // Entregador
        return const [HomeContent(), PerfilPage()];
      case 3: // Usuário
        return const [HomeContent(), PerfilPage(), ListProductPage()];
    }
    throw Exception('Privilegio não encontrado');
  }

  List<BottomNavigationBarItem> _buildNavItems(int privilegeId) {
    switch (privilegeId) {
      case 1: // Administrador
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Cadastro'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Usuário')
        ];
      case 2: // Entregador
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Usuário')
        ];
      case 3: //Usuário
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Usuário'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list), label: 'Lista de Produtos'),
        ];
      default:
        throw Exception("Privilégio não encontrado");
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = _buildPages(widget.privilegeId);
    final items = _buildNavItems(widget.privilegeId);
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
