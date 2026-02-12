import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../network/api_endpoints.dart';
import '../network/dio_client.dart';

class SocketController extends GetxController {
  late IO.Socket socket;

  RxBool isConnected = false.obs;
  RxBool showProductCard = false.obs;
  RxMap<String, dynamic> productData = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    connectSocket();
  }

  Future<void> connectSocket() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      print("TOKEN NOT FOUND");
      return;
    }

    socket = IO.io(
      'https://api.rushbaskets.com',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(3000)
          .setAuth({
        'token': token
      })
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      isConnected.value = true;
      print("✅ SOCKET CONNECTED SUCCESSFULLY");
    });

    socket.onConnectError((err) {
      print("❌ CONNECT ERROR: $err");
    });

    socket.onError((err) {
      print("❌ SOCKET ERROR: $err");
    });

    socket.onDisconnect((_) {
      isConnected.value = false;
      print("❌ SOCKET DISCONNECTED");
      _reconnect();
    });




    socket.on('order_assignment_request', (data) {
      debugPrint("📦 RAW SOCKET DATA RECEIVED:");
      debugPrint(data.toString());

      if (data is Map) {
        productData.value = Map<String, dynamic>.from(data);
      } else {
        debugPrint("⚠️ Unexpected data format: ${data.runtimeType}");
        return;
      }

      showProductCard.value = true;

      debugPrint("✅ PARSED PRODUCT DATA:");
      debugPrint(productData.toString());
    });

  }

  void _reconnect() {
    Future.delayed(const Duration(seconds: 5), () {
      if (!isConnected.value) {
        print("🔄 TRYING TO RECONNECT...");
        socket.connect();
      }
    });
  }

  RxBool isAcceptingOrder = false.obs;
  Future<void> acceptOrder() async {
    try {
      isAcceptingOrder.value = true;

      final orderId = productData['data']['_id'];

      final response = await DioClient.instance.post(
        "${ApiEndpoints.acceptOrder}/$orderId/accept",
      );

      debugPrint("✅ ORDER ACCEPTED: ${response.data}");

      Get.snackbar(
        "Order Accepted",
        "You have successfully accepted the order",
        snackPosition: SnackPosition.BOTTOM,
      );

      showProductCard.value = false;
      productData.clear();

    } on DioException catch (e) {
      debugPrint("❌ ACCEPT ORDER FAILED: ${e.response?.data}");
    } finally {
      isAcceptingOrder.value = false;
    }
  }

  Future<void> rejectOrder() async {
    try {
      isAcceptingOrder.value = true;

      final orderId = productData['data']['_id'];
      print("ORDER ID $orderId");

      final response = await DioClient.instance.post(
        "${ApiEndpoints.rejectOrder}/$orderId/reject",
      );

      debugPrint("❌ ORDER REJECTED: ${response.data}");

      Get.snackbar(
        "Order Rejected",
        "You have rejected the order",
        snackPosition: SnackPosition.BOTTOM,
      );

      showProductCard.value = false;
      productData.clear();

    } on DioException catch (e) {
      debugPrint("❌ REJECT ORDER FAILED: ${e.response?.data}");
    } finally {
      isAcceptingOrder.value = false;
    }
  }


  void clearProduct() {
    productData.clear();
    showProductCard.value = false;
  }

  @override
  void onClose() {
    socket.off('new_product');
    socket.disconnect();
    socket.destroy();
    super.onClose();
  }
}

