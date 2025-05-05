import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:padaria/data/models/user_model.dart';
import 'package:padaria/ui/home/home_page.dart';

class LoadingAnimationPage extends StatefulWidget {
  const LoadingAnimationPage({super.key});

  @override
  State<LoadingAnimationPage> createState() => _LoadingAnimationPageState();
}

class _LoadingAnimationPageState extends State<LoadingAnimationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final int privelegeId = ModalRoute.of(context)!.settings.arguments as int;
      Future.delayed(const Duration(seconds: 4), () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => HomePage(privilegeId: privelegeId)));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset('lib/ui/assets/lottie/login_post_animation.json',
            width: 600),
      ),
    );
  }
}
