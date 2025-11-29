import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  TermsConditionsPage({super.key});

  final Color primary = const Color(0xFFF28C28);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        title: const Text(
          "Terms & Conditions",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [

          _headerCard(),

          const SizedBox(height: 20),

          _sectionTitle("1. Introduction"),
          _sectionText(
              "Welcome to RushBasket. By using our services, you agree to the following terms and conditions."
          ),

          _sectionTitle("2. User Responsibilities"),
          _sectionText(
              "Users must provide accurate information while creating an account and placing orders."
          ),

          _sectionTitle("3. Delivery Policy"),
          _sectionText(
              "Delivery times may vary based on traffic, weather conditions, and order volume."
          ),

          _sectionTitle("4. Payment Policy"),
          _sectionText(
              "All payments are processed securely. RushBasket does not store your payment details."
          ),

          _sectionTitle("5. Cancellation Policy"),
          _sectionText(
              "Orders once dispatched cannot be cancelled. Refunds apply only under valid conditions."
          ),

          _sectionTitle("6. Contact"),
          _sectionText(
              "For any queries, contact support@rushbasket.com"
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // HEADER CARD
  Widget _headerCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.description_outlined, color: primary, size: 36),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              "Please read the following Terms & Conditions carefully before using RushBasket.",
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TITLE
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }

  // BODY TEXT
  Widget _sectionText(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 14,
          height: 1.45,
          color: Colors.black54,
        ),
      ),
    );
  }
}
