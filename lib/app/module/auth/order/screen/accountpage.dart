import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:riderrushbasketapp/app/module/auth/order/screen/accountpage/supportpage.dart';

import '../../../../widget/bottomnav.dart';
import '../../login/controller/login_controller.dart';
import '../../login/screen/login_page.dart';
import '../../onboarding/screen/onboarding_screen.dart';
import 'accountpage/allotedpage.dart';
import 'accountpage/askforleave.dart';
import 'accountpage/editpage.dart';
import 'accountpage/faqpage.dart';
import 'accountpage/privacypage.dart';
import 'accountpage/referearn.dart';
import 'accountpage/termcondition.dart';
import 'accountpage/walletpage.dart';
import 'order_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  final Color primary = const Color(0xFFF28C28); // RushBasket Orange

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNav(currentIndex: 3),

      backgroundColor: const Color(0xFFFFF7EF), // Soft light background
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_outline, color: primary, size: 22),
            const SizedBox(width: 6),
            Text(
              "Account",
              style: TextStyle(
                color: primary,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFF28C28), size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),


      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [

            const SizedBox(height: 20),

            /// ---------------- PROFILE CARD ----------------
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage("assets/png/pro.png"),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // NAME + RATING
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Aman Sharma",
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                          ),

                          Row(
                            children: [
                              Icon(Icons.star, color: primary, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                "4.9",
                                style: TextStyle(
                                  color: primary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      // PHONE ROW
                      Row(
                        children: [
                          Icon(Icons.phone, color: primary, size: 18),
                          const SizedBox(width: 6),
                          const Text(
                            "+91 9999988888",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // EMAIL ROW
                      Row(
                        children: [
                          Icon(Icons.email_outlined, color: primary, size: 18),
                          const SizedBox(width: 6),
                          const Expanded(
                            child: Text(
                              "loremipsum@gmail.com",
                              style: TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),






            /// ---------------- OPTIONS TITLE ----------------
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Options",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 14),

            /// ---------------- OPTIONS LIST ----------------
            _optionTile(Icons.person_outline, "Edit Profile", () {
              Get.to(() => EditProfilePage());
            }),
            _optionTile(Icons.account_balance_wallet_outlined, "Wallet", () {
              Get.to(() => const WalletPage());
            }),

            _optionTile(Icons.map_outlined, "Allotted Area", () {
              Get.to(() => AllottedAreaPage());
            }),
            _optionTile(Icons.card_giftcard, "Refer and Earn", () {
              Get.to(() => ReferEarnPage());
            }),
            _optionTile(Icons.headset_mic, "Support", () {
              Get.to(() => SupportPage());
            }),
            _optionTile(Icons.help_outline, "FAQ", () {
              Get.to(() => FAQPage());
            }),
            _optionTile(Icons.description_outlined, "Terms and Conditions", () {
              Get.to(() => TermsConditionsPage());
            }),
            _optionTile(Icons.lock_outline, "Privacy Policy", () {
              Get.to(() => PrivacyPolicyPage());
            }),
            _optionTile(Icons.beach_access_outlined, "Ask For Leave", () {
              Get.to(() => AskForLeavePage());
            }),


            const SizedBox(height: 10),

            /// ---------------- LOGOUT ----------------
            GestureDetector(
              onTap: () {
                Get.delete<LoginController>(); // (optional) clear previous instance
                Get.offAll(() {
                  Get.put(LoginController());
                  return LoginPage();
                });
              },
              child: _logoutTile(),
            ),




            const SizedBox(height: 20),

            const Text(
              "App Version 1.0.0 (30)",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      /// ---------------- BOTTOM NAVIGATION ----------------

    );
  }

  /// OPTION TILE
  Widget _optionTile(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFF28C28)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.black45),
          ],
        ),
      ),
    );
  }


  /// LOGOUT TILE
  Widget _logoutTile() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.logout, color: Color(0xFFF28C28)),
          SizedBox(width: 12),
          Text("Log Out",
              style: TextStyle(
                  color: Color(0xFFF28C28),
                  fontWeight: FontWeight.bold,
                  fontSize: 15)),
        ],
      ),
    );
  }

  /// BOTTOM NAV ITEM
  Widget _bottomNavItem(
      IconData icon, String label, bool active, VoidCallback onTap) {
    final Color primary = const Color(0xFFF28C28);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 26, color: active ? primary : Colors.black45),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: active ? primary : Colors.black54,
              fontWeight: active ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
