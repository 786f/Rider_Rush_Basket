// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:riderrushbasketapp/service/auth_service.dart';
// import '../../../../routes/app_routes.dart';
//
// class OtpController extends GetxController {
//   late String phone;
//   late bool isNewRider;
//
//   final otpControllers = List.generate(4, (_) => TextEditingController());
//   final focusNodes = List.generate(4, (_) => FocusNode());
//
//   var secondsRemaining = 30.obs;
//   var isVerifying = false.obs;
//
//   @override
//   void onInit() {
//     final args = Get.arguments as Map<String, dynamic>;
//
//     phone = args["mobile"];
//     isNewRider = args["isNewRider"] ?? false;
//
//     _startTimer();
//     super.onInit();
//   }
//
//   void handleOtpInput(int index, String value) {
//     if (value.isNotEmpty && index < 3) {
//       focusNodes[index + 1].requestFocus();
//     } else if (value.isEmpty && index > 0) {
//       focusNodes[index - 1].requestFocus();
//     }
//   }
//
//   void verifyOtp() async {
//     final otp = otpControllers.map((c) => c.text).join();
//
//     if (otp.length != 4) {
//       Get.snackbar("Error", "Enter valid 4-digit OTP");
//       return;
//     }
//
//     try {
//       isVerifying.value = true;
//
//       final response = await AuthService.verifyOtp(
//         mobile: phone,
//         otp: otp,
//       );
//       print( ' verify otp response: ${response}');
//       if (response["success"] == true) {
//         final token = response["token"];
//         final userData = response["data"];
//
//         Get.snackbar("Success", "OTP Verified");
//
//         if (isNewRider) {
//           Get.offAllNamed(AppRoutes.personal);
//         } else {
//           Get.offAllNamed(AppRoutes.home);
//         }
//       } else {
//         Get.snackbar("Error", response["message"] ?? "Invalid OTP");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Server error, try again");
//     } finally {
//       isVerifying.value = false;
//     }
//   }
//
//   void _startTimer() {
//     secondsRemaining.value = 30;
//
//     Future.doWhile(() async {
//       await Future.delayed(const Duration(seconds: 1));
//       if (secondsRemaining.value == 0) return false;
//       secondsRemaining.value--;
//       return true;
//     });
//   }
//
//   /// 🔄 RESEND OTP
//   void resendOtp() async {
//     _startTimer();
//     Get.snackbar("OTP Sent", "A new OTP has been sent");
//     // Optional: call sendOtp API again
//   }
//
//   @override
//   void onClose() {
//     for (final c in otpControllers) {
//       c.dispose();
//     }
//     for (final f in focusNodes) {
//       f.dispose();
//     }
//     super.onClose();
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>;

    phone = args["mobile"];
    isNewRider = args["isNewRider"] ?? false;

    _startTimer();
  }

  void handleOtpInput(int index, String value) {
    if (value.isNotEmpty && index < 3) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  void verifyOtp() async {
    final otp = otpControllers.map((c) => c.text).join();

    if (otp.length != 4) {
      Get.snackbar("Error", "Enter valid 4-digit OTP");
      return;
    }

    // try {
      isVerifying.value = true;

      final response = await AuthService.verifyOtp(
        mobile: phone,
        otp: otp,
      );

      print("VERIFY OTP RESPONSE CONTROLLER: $response");

      if (response["success"] == true) {
        final token = response["token"];
        final userData = response["data"];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("auth_token", token);

        print("TOKEN SAVED: $token");
        print("USER DATA: $userData");

        Get.snackbar("Success", "OTP Verified Successfully");

        if (userData["approvalStatus"] == "pending") {
          Get.offAllNamed(AppRoutes.personal);
        } else {
          Get.offAllNamed(AppRoutes.home);
        }
      } else {
        Get.snackbar("Error", response["message"] ?? "Invalid OTP");
      }
    // } catch (e) {
    //   print("OTP VERIFY CONTROLLER ERROR: $e");
    //   Get.snackbar("Error", "Server error, please try again");
    // } finally {
    //   isVerifying.value = false;
    // }
  }

  void _startTimer() {
    secondsRemaining.value = 30;

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (secondsRemaining.value == 0) return false;
      secondsRemaining.value--;
      return true;
    });
  }

  void resendOtp() async {
    _startTimer();
    Get.snackbar("OTP Sent", "A new OTP has been sent");
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
