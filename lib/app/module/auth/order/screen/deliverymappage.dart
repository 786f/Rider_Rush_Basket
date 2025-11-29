import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:riderrushbasketapp/app/module/auth/order/screen/order_page.dart';

class DeliveryMapPage extends StatelessWidget {
  const DeliveryMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ------------------ MAP IMAGE ------------------
          Positioned.fill(
            child: Image.asset(
              "assets/png/map.jpg", // replace with your image
              fit: BoxFit.cover,
            ),
          ),

          // ------------------ TOP APP BAR ------------------
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      shape: BoxShape.circle,
                    ),
                    child: GestureDetector(
                        onTap: () => Get.to(OrdersPage()), // Correct syntax
                        child: Icon(Icons.arrow_back_ios, color: Colors.black)),

                  ),
                  // Title
                  Text(
                    "Track Order",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  // Empty space for alignment
                  SizedBox(width: 40),
                ],
              ),
            ),
          ),

          // ------------------ BOTTOM CUSTOMER CARD ------------------
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Customer info row
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.orange.shade100,
                        child: Icon(Icons.person, color: Colors.orange),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Aman Sharma",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "201/D, Ananta Apts, Andheri 400069",
                            style:
                            TextStyle(fontSize: 13, color: Colors.black54),
                          ),
                        ],
                      ),
                      Spacer(),
                      // ETA badge

                    ],
                  ),

                  SizedBox(height: 20),

                  // Distance + Delivery type row
                  Row(
                    children: [
                      Icon(Icons.timer, color: Colors.orange, size: 16),
                      SizedBox(width: 4),
                      Text(
                        "25 mins",
                        style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Icon(Icons.directions_walk,
                          color: Colors.orange, size: 20),
                      SizedBox(width: 6),
                      Text("2.5 km",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      SizedBox(width: 20),
                      Icon(Icons.shopping_bag, color: Colors.orange, size: 20),
                      SizedBox(width: 6),
                      Text("Right-side Basket",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                    ],
                  ),

                  SizedBox(height: 25),

                  // Start Delivery Button
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Get.to(OrdersPage()), // Correct syntax
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade600,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Start Delivery",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
