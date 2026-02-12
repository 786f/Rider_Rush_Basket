import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../order/orders_controller.dart';

class OrdersScreen extends StatelessWidget {
  OrdersScreen({super.key});

  final OrdersController controller = Get.put(OrdersController());

  static const Color primaryOrange = Color(0xffF57C00);
  static const Color bgColor = Color(0xffF5F6FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("My Orders"),
        centerTitle: true,
        backgroundColor: primaryOrange,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.isNotEmpty) {
          return Center(child: Text(controller.error.value));
        }

        if (controller.orders.isEmpty) {
          return const Center(child: Text("No delivered orders"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.orders.length,
          itemBuilder: (context, index) {
            return _orderCard(controller.orders[index]);
          },
        );
      }),
    );
  }

  /// ================= ORDER CARD =================

  Widget _orderCard(Map<String, dynamic> order) {
    final pricing = order['pricing'] ?? {};
    final address = order['shippingAddress'] ?? {};
    final user = order['user'] ?? {};
    final items = order['items'] ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(16),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        collapsedShape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Order #${order['orderNumber']}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            _statusBadge(order['status']),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            "₹${pricing['total']}",
            style: const TextStyle(
              color: primaryOrange,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        children: [
          _sectionTitle("Customer"),
          _iconRow(Icons.person, user['userName']),
          _iconRow(Icons.phone, user['contactNumber']),

          const SizedBox(height: 12),

          _sectionTitle("Delivery Address"),
          _iconRow(
            Icons.location_on,
            "${address['line1']}, ${address['city']}",
          ),

          const Divider(height: 28),

          _sectionTitle("Items"),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map<Widget>((item) {
              return Chip(
                backgroundColor: bgColor,
                label: Text(
                  "${item['productName']} × ${item['quantity']}",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              );
            }).toList(),
          ),

          const Divider(height: 28),

          _sectionTitle("Pricing"),
          _infoRow("Subtotal", "₹${pricing['subtotal']}"),
          _infoRow("Tax", "₹${pricing['tax']}"),
          _infoRow("Delivery Fee", "₹${order['deliveryAmount']}"),
          const SizedBox(height: 6),
          _infoRow(
            "Total",
            "₹${pricing['total']}",
            isBold: true,
            color: primaryOrange,
          ),
        ],
      ),
    );
  }

  /// ================= UI HELPERS =================

  Widget _statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toString().toUpperCase(),
        style: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _iconRow(IconData icon, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black54),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value ?? "--",
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
      String label,
      String value, {
        bool isBold = false,
        Color? color,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
