import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 16),
            const Text('Onboarding Submitted', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('We will verify your documents and get back to you.'),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: () => Get.offAllNamed('/'), child: const Text('Back to Home')),
          ],
        ),
      ),
    );
  }
}
