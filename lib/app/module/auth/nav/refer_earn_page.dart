import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:share_plus/share_plus.dart';

class ReferEarnPage extends StatelessWidget {

  ReferEarnPage({super.key});

  static const Color primaryOrange = Color(0xffF57C00);
  static const Color bgColor = Color(0xffFFF7F1);

  /// Example Referral Code
  final String referralCode = "RIDER123";

  void copyCode() {
    Clipboard.setData(ClipboardData(text: referralCode));
  }

  void shareCode() {
    // Share.share(
    //   "Join Rush Basket Rider App using my referral code $referralCode and start earning today!",
    // );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: bgColor,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryOrange),
        title: const Text(
          "Refer & Earn",
          style: TextStyle(
            color: primaryOrange,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            /// TOP IMAGE
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [

                  const Icon(
                    Icons.card_giftcard,
                    size: 70,
                    color: primaryOrange,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Invite Friends & Earn",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryOrange,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Share your referral code and earn rewards when your friends join and complete deliveries.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 20),

            /// REFERRAL CODE CARD
            Container(

              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primaryOrange),
              ),

              child: Column(
                children: [

                  const Text(
                    "Your Referral Code",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    referralCode,
                    style: const TextStyle(
                      fontSize: 24,
                      letterSpacing: 3,
                      fontWeight: FontWeight.bold,
                      color: primaryOrange,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton.icon(

                    onPressed: () {
                      copyCode();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Referral Code Copied"),
                        ),
                      );
                    },

                    icon: const Icon(Icons.copy),

                    label: const Text("Copy Code"),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryOrange,
                    ),

                  )

                ],
              ),
            ),

            const SizedBox(height: 20),

            /// SHARE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(

                onPressed: shareCode,

                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryOrange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),

                child: const Text(
                  "Share Referral Code",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ),
            ),

            const SizedBox(height: 30),

            /// HOW IT WORKS
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "How it works",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            _stepTile(
              icon: Icons.share,
              title: "Share your code",
              subtitle: "Invite friends using your referral code",
            ),

            _stepTile(
              icon: Icons.person_add,
              title: "Friend signs up",
              subtitle: "Your friend registers using your code",
            ),

            _stepTile(
              icon: Icons.delivery_dining,
              title: "Complete deliveries",
              subtitle: "Your friend completes first deliveries",
            ),

            _stepTile(
              icon: Icons.currency_rupee,
              title: "Earn rewards",
              subtitle: "You receive referral bonus",
            ),

          ],
        ),
      ),
    );
  }

  /// STEP TILE
  Widget _stepTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {

    return Container(

      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(

        children: [

          CircleAvatar(
            backgroundColor: primaryOrange.withOpacity(0.1),
            child: Icon(icon, color: primaryOrange),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),

              ],
            ),
          )

        ],
      ),
    );
  }
}