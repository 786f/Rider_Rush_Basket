import 'package:flutter/material.dart';

import '../module/auth/onboarding/screen/onboarding_screen.dart';
import '../module/auth/order/screen/accountpage.dart';
import '../module/auth/order/screen/earningpage.dart';
import '../module/auth/order/screen/order_page.dart';


class BottomNav extends StatelessWidget {
  final int currentIndex; // 0 = Home, 1 = Order, 2 = Earning, 3 = Account

  const BottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    const Color activeColor = Color(0xFFF28C28);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _item(
            icon: Icons.home_outlined,
            label: "Home",
            active: currentIndex == 0,
            onTap: () {
              if (currentIndex != 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) =>  OnboardingPage()),
                );
              }
            },
          ),

          _item(
            icon: Icons.shopping_bag,
            label: "Order",
            active: currentIndex == 1,
            onTap: () {
              if (currentIndex != 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const OrdersPage()),
                );
              }
            },
          ),

          _item(
            icon: Icons.currency_rupee,
            label: "Earning",
            active: currentIndex == 2,
            onTap: () {
              if (currentIndex != 2) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const AdvancedEarningDashboard()),
                );
              }
            },
          ),

          _item(
            icon: Icons.person_outline,
            label: "Account",
            active: currentIndex == 3,
            onTap: () {
              if (currentIndex != 3) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const AccountPage()),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  /// Bottom nav item widget
  Widget _item({
    required IconData icon,
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    const Color primary = Color(0xFFF28C28);

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
