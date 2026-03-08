import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
      ),
    );
  }

  Widget _sectionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black87,
          height: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Privacy Policy",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "Rider App Privacy Policy",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Last Updated: March 2026",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 20),

                _sectionText(
                    "Your privacy is important to us. This Privacy Policy explains how the Rider App collects, uses, and protects your information when you use our mobile application."
                ),

                _sectionTitle("1. Information We Collect"),

                _sectionText(
                    "When you use the Rider App, we may collect personal information such as your name, phone number, email address, location, and profile details to provide delivery services."
                ),

                _sectionText(
                    "We may also collect device information such as device type, operating system, and app usage data to improve the performance of our services."
                ),

                _sectionTitle("2. Location Information"),

                _sectionText(
                    "The Rider App collects real-time location data to enable delivery tracking, route navigation, and order management. Location access is required while the rider is actively delivering orders."
                ),

                _sectionTitle("3. How We Use Your Information"),

                _sectionText(
                    "Your information is used to operate and improve our services, process deliveries, manage rider accounts, communicate important updates, and ensure security of the platform."
                ),

                _sectionTitle("4. Data Security"),

                _sectionText(
                    "We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, loss, misuse, or alteration."
                ),

                _sectionTitle("5. Sharing of Information"),

                _sectionText(
                    "We do not sell or rent your personal information. Information may be shared only with trusted partners necessary to operate the delivery services, such as order processing systems."
                ),

                _sectionTitle("6. Your Rights"),

                _sectionText(
                    "You have the right to access, update, or delete your personal information at any time by contacting support or updating your profile inside the application."
                ),

                _sectionTitle("7. Changes to This Policy"),

                _sectionText(
                    "We may update this Privacy Policy from time to time. Any changes will be posted within the application."
                ),

                _sectionTitle("8. Contact Us"),

                _sectionText(
                    "If you have any questions regarding this Privacy Policy, please contact our support team through the Rider App."
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}