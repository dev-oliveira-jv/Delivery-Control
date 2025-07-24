import 'package:flutter/material.dart';
import 'package:padaria/core/services/auth_service.dart';
import 'package:padaria/data/models/user_model.dart';
import '../../core/services/user_service.dart';

class SelectUserPage extends StatelessWidget {
  final UserService userService = UserService();
  SelectUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Selecionar Cliente"),
      ),
      body: FutureBuilder<List<UserModel>>(
          future: userService.getUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Nenhum cliente encontrado"),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text("Erro: ${snapshot.error}"),
              );
            }
            final users = snapshot.data ?? [];

            if (users.isEmpty) {
              return const Center(
                child: Text("Nenhum cliente encontrado"),
              );
            }
            return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text(user.username ?? ""),
                    subtitle: Text(user.obejectId ?? ""),
                    onTap: () => Navigator.pop(context, user),
                  );
                });
          }),
    );
  }
}
