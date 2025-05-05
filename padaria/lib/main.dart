import 'package:flutter/material.dart';
import 'package:padaria/ui/login/login_page.dart';
import 'package:padaria/ui/widgets/animations/loading_animation_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Padaria',
      theme: ThemeData(
          primarySwatch: Colors.brown,
          textSelectionTheme:
              const TextSelectionThemeData(cursorColor: Colors.black)),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(), // Certifique-se de que sua página está aqui
      routes: {'/animation': (context) => const LoadingAnimationPage()},
    );
  }
}
