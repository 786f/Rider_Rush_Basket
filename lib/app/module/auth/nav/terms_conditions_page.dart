import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({Key? key}) : super(key: key);

  Widget sectionTitle(String title) {
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

  Widget sectionText(String text) {
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
          "Terms & Conditions",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
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
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "Rider App Terms & Conditions",
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

                sectionText(
                    "These Terms and Conditions govern your use of the Rider App. By using this application, you agree to comply with these terms."
                ),

                sectionTitle("1. Rider Responsibilities"),

                sectionText(
                    "Riders must deliver orders safely, follow assigned routes, and maintain professionalism while interacting with customers."
                ),

                sectionTitle("2. Account Usage"),

                sectionText(
                    "Each rider must use their own registered account. Sharing login credentials or allowing others to access your account is strictly prohibited."
                ),

                sectionTitle("3. Delivery Guidelines"),

                sectionText(
                    "Riders must pick up and deliver orders within the expected delivery time and ensure proper handling of products during transportation."
                ),

                sectionTitle("4. Location Tracking"),

                sectionText(
                    "The Rider App may track your location while you are online or delivering orders to ensure proper order tracking and delivery verification."
                ),

                sectionTitle("5. Payments & Earnings"),

                sectionText(
                    "Earnings will be calculated based on completed deliveries. Payments may be processed according to the company's payout schedule."
                ),

                sectionTitle("6. Misuse of Platform"),

                sectionText(
                    "Any misuse of the platform, including fraudulent activity, fake deliveries, or manipulation of orders, may result in account suspension or termination."
                ),

                sectionTitle("7. Suspension or Termination"),

                sectionText(
                    "The company reserves the right to suspend or terminate rider accounts if these terms are violated."
                ),

                sectionTitle("8. Changes to Terms"),

                sectionText(
                    "These Terms and Conditions may be updated at any time. Riders will be notified of significant changes through the application."
                ),

                sectionTitle("9. Contact Support"),

                sectionText(
                    "If you have questions regarding these Terms & Conditions, please contact rider support through the app."
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