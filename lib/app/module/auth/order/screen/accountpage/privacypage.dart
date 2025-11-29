import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  PrivacyPolicyPage({super.key});

  final Color primary = const Color(0xFFF28C28);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        title: const Text(
          "Privacy Policy",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [

          _headerCard(),

          const SizedBox(height: 20),

          _sectionTitle("1. Overview"),
          _sectionText(
              "RushBasket respects your privacy and is committed to protecting your personal information."
          ),

          _sectionTitle("2. Data Collection"),
          _sectionText(
              "We collect user data including name, contact number, email, location, and order details for service improvement."
          ),

          _sectionTitle("3. Use of Information"),
          _sectionText(
              "Your information is used to improve delivery accuracy, customer support, and personalized app experience."
          ),

          _sectionTitle("4. Data Security"),
          _sectionText(
              "All your data is encrypted and securely stored. We never share or sell your information to third-party companies."
          ),

          _sectionTitle("5. Cookies & Tracking"),
          _sectionText(
              "We may use cookies for analytics and enhancing user performance within the app."
          ),

          _sectionTitle("6. Contact"),
          _sectionText(
              "If you have any concerns, contact us at support@rushbasket.com"
          ),

          const SizedBox(height: 25),
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
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.privacy_tip_outlined, color: primary, size: 36),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              "We value your privacy. Learn how RushBasket collects and protects your information.",
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

  // SECTION TITLE
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 6),
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

  // SECTION PARAGRAPH
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
