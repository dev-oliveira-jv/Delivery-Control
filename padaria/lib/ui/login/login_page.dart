import 'package:flutter/material.dart';
import 'package:padaria/data/models/user_model.dart';
import 'package:padaria/ui/widgets/animations/loading_animation_page.dart';
import '../../core/services/auth_service.dart';
import '../widgets/animations/fade_transition_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  late UserModel user;

  void _login() async {
    try {
      final user = await _authService.login(
        _usernameController.text,
        _passwordController.text,
      );
      // ignore: avoid_print
      print("Privilegio: ${user.privelege?['number']}");
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login bem-sucedido! ${user.username}")),
      );
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/animation', arguments: {
        'privelegeId': user.privelegeId,
        'userModel': user,
      });
      // Aqui você pode navegar para outra tela ou salvar o sessionToken
    } catch (e) {
      //ignore: avoid_print
      print("Erro ao fazer login: $e");
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Usuário ou senha incorretos.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     "Login",
      //     textAlign: TextAlign.center,
      //     textScaler: TextScaler.linear(2),
      //   ),
      // ),
      body: FadeInWidget(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  Image.asset('lib/ui/assets/logo_login.png'),
                  const SizedBox(height: 40),
                  TextField(
                    cursorColor: Colors.black,
                    controller: _usernameController,
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelText: "Usuário",
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 56, 55, 55),
                      ),
                    ),
                    obscureText: false,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    cursorColor: Colors.black,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelText: "Senha",
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 56, 55, 55),
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _login();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 240, 225, 222),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
