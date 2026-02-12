import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riderrushbasketapp/app/module/auth/nav/profile_screen.dart';

import '../websocket/incoming_product_screen.dart';
import 'bottom_nav_controller.dart';
import 'orders_screen.dart';

class BottomNavScreen extends StatelessWidget {
  BottomNavScreen({super.key});

  final BottomNavController controller =
  Get.put(BottomNavController());

  final List<Widget> pages = [
    OrdersScreen(),
    IncomingProductScreen(),
    ProfileScreen(),
  ];

  static const Color primaryOrange = Color(0xffF57C00);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: pages[controller.currentIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeIndex,
          selectedItemColor: primaryOrange,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: "Orders",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_active),
              label: "Live Orders",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      );
    });
  }
}
