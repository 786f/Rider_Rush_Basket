import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riderrushbasketapp/app/module/auth/websocket/socket_controller.dart';

class IncomingProductScreen extends StatelessWidget {
  IncomingProductScreen({super.key});

  final SocketController socketController = Get.put(SocketController());

  static const Color primaryOrange = Color(0xffF57C00);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryOrange,
        title: const Text("New Order"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (!socketController.showProductCard.value) {
          return _noOrderUI();
        }

        final data = socketController.productData;
        final orderData = data['data'];
        final order = orderData['order'];
        final pricing = orderData['pricing'] ?? {};
        final address = order['shippingAddress'] ?? {};
        final user = orderData['user'] ?? {};
        final vendor = (orderData['vendors'] ?? []).isNotEmpty
            ? orderData['vendors'][0]
            : {};

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionCard(
                title: "Order Information",
                children: [
                  _row("Order ID", orderData['orderId']),
                  _row("Order Number", orderData['orderNumber']),
                  _row("Status", order['status']),
                  _row("Amount", "₹${pricing['total']}"),
                  _row("Delivery Charge", "₹${pricing['deliveryCharge']}"),
                ],
              ),

              _sectionCard(
                title: "Shipping Address",
                children: [
                  _row("Line 1", address['line1']),
                  _row("Line 2", address['line2']),
                  _row("City", address['city']),
                  _row("State", address['state']),
                  _row("Pin Code", address['pinCode']),
                ],
              ),

              _sectionCard(
                title: "User Details",
                children: [
                  _row("Name", user['userName']),
                  _row("Phone", user['contactNumber']),
                  _row("Email", user['email']),
                ],
              ),

              _sectionCard(
                title: "Vendor Details",
                children: [
                  _row("Vendor Name", vendor['vendorName']),
                  _row("Store", vendor['storeName']),
                  _row("Contact", vendor['contactNumber']),
                ],
              ),

              _sectionCard(
                title: "Pricing Details",
                children: [
                  _row("Subtotal", "₹${pricing['subtotal']}"),
                  _row("Tax", "₹${pricing['tax']}"),
                  _row("Handling", "₹${pricing['handlingCharge']}"),
                  _row("Total", "₹${pricing['total']}"),
                ],
              ),
            ],
          ),
        );
      }),

      /// ACTION BUTTONS
      bottomSheet: Obx(() {
        if (!socketController.showProductCard.value) {
          return const SizedBox();
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Colors.black26,
              )
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: socketController.rejectOrder,
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
                    socketController.acceptOrder();
                    // socketController.clearProduct();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Accept",style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// -------------------- UI HELPERS --------------------

  Widget _noOrderUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.inventory_2_outlined,
              size: 80, color: Colors.black26),
          SizedBox(height: 12),
          Text(
            "No new orders right now",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 6),
          Text(
            "Stay online to receive orders",
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(
      {required String title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black.withOpacity(0.05),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: primaryOrange,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          ...children,
        ],
      ),
    );
  }

  Widget _row(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Flexible(
            child: Text(
              value?.toString() ?? "N/A",
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
