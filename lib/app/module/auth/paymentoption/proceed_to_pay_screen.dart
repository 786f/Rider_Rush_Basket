import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'mark_payment_controller.dart';

class ProceedToPayScreen extends StatefulWidget {
  final double amount;
  final String orderId;

  const ProceedToPayScreen({
    super.key,
    required this.amount,
    required this.orderId,
  });

  @override
  State<ProceedToPayScreen> createState() => _ProceedToPayScreenState();
}

class _ProceedToPayScreenState extends State<ProceedToPayScreen> {
  String selectedMethod = "cash";

  static const Color primaryOrange = Color(0xffF57C00);
  static const Color bgColor = Color(0xffFFF7F1);

  final MarkPaymentController paymentController =
  Get.put(MarkPaymentController());

  // If you already have AuthController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // 🔶 Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: const BoxDecoration(
                color: primaryOrange,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Collect Payment",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🔶 Amount Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Amount to Collect",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "₹${widget.amount}",
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: primaryOrange),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🔶 Payment Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _paymentOption(
                    title: "Cash",
                    icon: Icons.money,
                    value: "cash",
                  ),
                  const SizedBox(height: 15),
                  _paymentOption(
                    title: "Online",
                    icon: Icons.qr_code,
                    value: "online",
                  ),
                ],
              ),
            ),

            const Spacer(),

            // 🔶 Confirm Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(() => ElevatedButton(
                onPressed: paymentController.isLoading.value
                    ? null
                    : () {
                  if (selectedMethod == "online") {
                    Get.snackbar(
                      "Coming Soon",
                      "Online payment feature is coming soon",
                      backgroundColor: Colors.orange,
                      colorText: Colors.white,
                    );
                  } else {
                    final String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5OGIwMTFkMWI0OWU4OGE5MmI3ZWYxOSIsInJvbGUiOiJyaWRlciIsImlhdCI6MTc3MDcxODAwNiwiZXhwIjoxNzcxMzIyODA2fQ.RQEEziapQBnVtT3LS-3m5slXm1f254YmrurhZJvgaSw";


                    paymentController.markCashPayment(
                      orderId: widget.orderId,
                      token: token,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryOrange,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: paymentController.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Confirm Payment",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _paymentOption({
    required String title,
    required IconData icon,
    required String value,
  }) {
    bool isSelected = selectedMethod == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
          isSelected ? primaryOrange.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? primaryOrange : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isSelected ? primaryOrange : Colors.black54),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? primaryOrange
                        : Colors.black87),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: primaryOrange)
          ],
        ),
      ),
    );
  }
}

