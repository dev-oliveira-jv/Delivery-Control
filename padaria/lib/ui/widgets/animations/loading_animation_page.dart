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
  late int privelegeId;
  late UserModel userModel;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      privelegeId = args['privelegeId'] as int;
      userModel = args['userModel'] as UserModel;

      Future.delayed(const Duration(seconds: 4), () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => HomePage(
                      privelegeId: privelegeId,
                      userModel: userModel,
                    )));
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
