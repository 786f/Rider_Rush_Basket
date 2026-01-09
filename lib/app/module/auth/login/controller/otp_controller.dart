import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riderrushbasketapp/service/auth_service.dart';
import '../../../../routes/app_routes.dart';

class OtpController extends GetxController {
  late String phone;
  late bool isNewRider;

  final otpControllers = List.generate(4, (_) => TextEditingController());
  final focusNodes = List.generate(4, (_) => FocusNode());

  var secondsRemaining = 30.obs;
  var isVerifying = false.obs;

  @override
  void onInit() {
    final args = Get.arguments as Map<String, dynamic>;

    phone = args["mobile"];
    isNewRider = args["isNewRider"] ?? false;

    _startTimer();
    super.onInit();
  }

  void handleOtpInput(int index, String value) {
    if (value.isNotEmpty && index < 3) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  /// ✅ VERIFY OTP API
  void verifyOtp() async {
    final otp = otpControllers.map((c) => c.text).join();

    if (otp.length != 4) {
      Get.snackbar("Error", "Enter valid 4-digit OTP");
      return;
    }

    try {
      isVerifying.value = true;

      final response = await AuthService.verifyOtp(
        mobile: phone,
        otp: otp,
      );
      print('response: ${response}');
      if (response["success"] == true) {
        final token = response["token"];
        final userData = response["data"];

        // TODO: Save token using SharedPreferences if needed
        // print(token);

        Get.snackbar("Success", "OTP Verified");

        if (isNewRider) {
          Get.offAllNamed(AppRoutes.personal); // new rider flow
        } else {
          Get.offAllNamed(AppRoutes.home); // existing rider
        }
      } else {
        Get.snackbar("Error", response["message"] ?? "Invalid OTP");
      }
    } catch (e) {
      Get.snackbar("Error", "Server error, try again");
    } finally {
      isVerifying.value = false;
    }
  }

  /// ⏱ OTP TIMER
  void _startTimer() {
    secondsRemaining.value = 30;

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (secondsRemaining.value == 0) return false;
      secondsRemaining.value--;
      return true;
    });
  }

  /// 🔄 RESEND OTP
  void resendOtp() async {
    _startTimer();
    Get.snackbar("OTP Sent", "A new OTP has been sent");
    // Optional: call sendOtp API again
  }

  @override
  void onClose() {
    for (final c in otpControllers) {
      c.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }
    super.onClose();
  }
}
