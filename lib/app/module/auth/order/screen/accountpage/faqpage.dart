import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  FAQPage({super.key});

  final Color primary = const Color(0xFFF28C28);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        title: const Text(
          "FAQ",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          _faqCard(
            "How to update profile?",
            "Go to Account → Edit Profile.",
          ),

          _faqCard(
            "How to contact support?",
            "Go to Account → Support.",
          ),

          _faqCard(
            "How do I check order status?",
            "Go to Orders → Select your active order.",
          ),

          _faqCard(
            "What is the delivery time?",
            "RushBasket delivers in 15–20 minutes depending on your location.",
          ),

          _faqCard(
            "Can I change my address?",
            "Yes, go to Account → Address → Edit.",
          ),
        ],
      ),
    );
  }

  Widget _faqCard(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            answer,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
