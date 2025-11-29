import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';

class LoginController extends GetxController {
  var phone = ''.obs;

  void sendOtp() {
    if (phone.value.length == 10) {
      Get.toNamed(AppRoutes.otp, arguments: phone.value);
    } else {
      Get.snackbar("Invalid Number", "Please enter a valid 10-digit number");
    }
  }
}
