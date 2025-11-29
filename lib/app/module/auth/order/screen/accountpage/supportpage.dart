import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class SupportPage extends StatelessWidget {
  SupportPage({super.key});

  final Color primary = const Color(0xFFF28C28);

  /// ------ Launcher Helper ------
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7EF),

      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 3,
        shadowColor: Colors.black12,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.headset_mic, color: primary, size: 22),
            const SizedBox(width: 6),
            Text(
              "Support",
              style: TextStyle(
                color: primary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// --------- HEADER TEXT ---------
            Text(
              "Need help?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "We're here for you! Contact us using any method below.",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 25),

            /// --------- SUPPORT OPTIONS ---------
            _supportTile(
              icon: Icons.phone_in_talk_rounded,
              title: "Call Support",
              subtitle: "99999 88888",
              iconColor: Colors.green,
              onTap: () => _launchURL("tel:9999988888"),
            ),

            _supportTile(
              icon: Icons.email_outlined,
              title: "Email Support",
              subtitle: "support@rushbasket.com",
              iconColor: Colors.blue,
              onTap: () => _launchURL("mailto:support@rushbasket.com"),
            ),

            _supportTile(
              icon: Icons.message_rounded,
              title: "WhatsApp Chat",
              subtitle: "Message us anytime",
              iconColor: Colors.teal,
              onTap: () => _launchURL("https://wa.me/9999988888"),
            ),

            const SizedBox(height: 20),

            /// --------- INFO MESSAGE ---------
            Center(
              child: Text(
                "Support available 7 days a week • 7 AM - 10 PM",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// -------- SUPPORT TILE WIDGET --------
  Widget _supportTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                        fontSize: 13, color: Colors.black45),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 16, color: Colors.black45)
          ],
        ),
      ),
    );
  }
}
