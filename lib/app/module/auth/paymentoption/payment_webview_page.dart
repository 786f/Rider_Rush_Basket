import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';


class PaymentWebViewPage extends StatefulWidget {
  final String paymentUrl;
  final String orderId;

  const PaymentWebViewPage({
    Key? key,
    required this.paymentUrl,
    required this.orderId,
  }) : super(key: key);

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => isLoading = true);
          },
          onPageFinished: (url) {
            setState(() => isLoading = false);
          },
          onNavigationRequest: (request) {
            if (request.url.contains("payment-success")) {
              handlePaymentSuccess(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  Future<void> handlePaymentSuccess(String url) async {
    Uri uri = Uri.parse(url);

    print("Main Url $uri");

    String? paymentId = uri.queryParameters['razorpay_payment_id'];
    String? paymentLinkId = uri.queryParameters['razorpay_payment_link_id'];
    String? signature = uri.queryParameters['razorpay_signature'];
    String? status = uri.queryParameters['razorpay_payment_link_status'];

    if (status == "paid" &&
        paymentId != null &&
        paymentLinkId != null &&
        signature != null) {
      await verifyPayment(
        paymentId: paymentId,
        paymentLinkId: paymentLinkId,
        signature: signature,
      );
    } else {
      Navigator.pop(context, false);
    }
  }

  Future<void> verifyPayment({
    required String paymentId,
    required String paymentLinkId,
    required String signature,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      final response = await http.post(
        Uri.parse("https://api.rushbaskets.com/api/payment/rider/verify"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "orderId": widget.orderId,
          "paymentData": {
            "razorpay_payment_id": paymentId,
            "razorpay_payment_link_id": paymentLinkId,
            "razorpay_signature": signature
          },
          "gateway": "razorpay"
        }),
      );

      if (response.statusCode == 200) {
        print("Payment Verified: ${response.body}");
       // Get.offAll(() => YourOrdersPage());



      } else {
        print("Verification Failed: ${response.body}");
        if (!mounted) return;
        Navigator.pop(context, false);
      }
    } catch (e) {
      print("Verification Error: $e");
      if (!mounted) return;
      Navigator.pop(context, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              WebViewWidget(controller: controller),

              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
