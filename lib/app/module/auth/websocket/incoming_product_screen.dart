import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riderrushbasketapp/app/module/auth/websocket/socket_controller.dart';

class IncomingProductScreen extends StatelessWidget {
  IncomingProductScreen({super.key});

  final SocketController socketController = Get.put(SocketController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: AppBar(
        title: const Text("New Order"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (!socketController.showProductCard.value) {
          return const Center(
            child: Text(
              "Waiting for orders...",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        final data = socketController.productData;
        final order = data['data']['order'];
        final item = order['items'][0];

        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                Text(
                  data['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                /// MESSAGE
                Text(
                  data['message'],
                  style: const TextStyle(color: Colors.black54),
                ),

                const Divider(height: 24),

                /// ORDER INFO
                _infoRow("Order ID", data['data']['orderNumber']),
                _infoRow("Product", item['productName']),
                _infoRow("Quantity", item['quantity'].toString()),
                _infoRow("Total", "₹${item['totalPrice']}"),

                const SizedBox(height: 16),

                /// BUTTONS
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          socketController.clearProduct();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Reject",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Emit accept event
                          socketController.clearProduct();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Accept"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
              const TextStyle(color: Colors.black54, fontSize: 14)),
          Text(value,
              style:
              const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
