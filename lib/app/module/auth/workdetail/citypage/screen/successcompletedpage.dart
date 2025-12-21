import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riderrushbasketapp/app/module/auth/onboarding/screen/onboarding_screen.dart';

class SuccessCompletedPage extends StatefulWidget {
  final String message;        // 🔥 Dynamic title: Work / Document / Anything

  const SuccessCompletedPage({super.key, required this.message});

  @override
  _SuccessCompletedPageState createState() => _SuccessCompletedPageState();
}

class _SuccessCompletedPageState extends State<SuccessCompletedPage> {
  @override
  void initState() {
    super.initState();

    // Auto redirect after 2 seconds
    Timer(const Duration(seconds: 2), () {
      Get.offAll(() => OnboardingPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7EF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // ✔️ Success Icon
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF4A76B9).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(25),
              child: const Icon(
                Icons.check_circle,
                color: Color(0xFF1A3C6E),
                size: 100,
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 Dynamic Text
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Redirecting to onboarding...",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
