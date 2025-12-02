import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../routes/app_routes.dart';

class OtpController extends GetxController {
  late String phone;

  var otpControllers = List.generate(4, (index) => TextEditingController());
  var focusNodes = List.generate(4, (index) => FocusNode());

  var secondsRemaining = 30.obs;
  late Worker timerWorker;

  @override
  void onInit() {
    phone = Get.arguments ?? "";

    _startTimer();
    super.onInit();
  }

  void handleOtpInput(int index, String value) {
    if (value.isNotEmpty && index < 3) {
      FocusScope.of(Get.context!).requestFocus(focusNodes[index + 1]);
    }

    if (value.isEmpty && index > 0) {
      FocusScope.of(Get.context!).requestFocus(focusNodes[index - 1]);
    }
  }

  void verifyOtp() {
    String otp = otpControllers.map((c) => c.text).join("");

    if (otp.length == 4) {
      Get.snackbar("Success", "OTP Verified!");

      Future.delayed(const Duration(milliseconds: 300), () {
        Get.offAllNamed(AppRoutes.personal);  // <<< NAVIGATE TO HOME
      });
    } else {
      Get.snackbar("Error", "Enter valid 4-digit OTP");
    }
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (secondsRemaining.value == 0) return false;
      secondsRemaining.value--;
      return true;
    });
  }

  void resendOtp() {
    secondsRemaining.value = 30;
    _startTimer();
    Get.snackbar("OTP Sent", "A new OTP has been sent");
  }
}