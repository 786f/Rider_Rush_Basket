import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/splash_controller.dart';


class SplashPage extends GetWidget<SplashController> {
  const SplashPage({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/png/rushbasket.png"),
          ],
        ),
      ),
    );
  }
}
