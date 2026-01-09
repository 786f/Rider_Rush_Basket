import 'package:get/get.dart';
import 'package:riderrushbasketapp/service/auth_service.dart';

import '../../../../routes/app_routes.dart';

class LoginController extends GetxController {
  var phone = ''.obs;
  var isLoading = false.obs;

  void sendOtp() async {
    if (phone.value.length != 10) {
      Get.snackbar("Invalid Number", "Please enter a valid 10-digit number");
      return;
    }

    try {
      isLoading.value = true;

      final response = await AuthService.sendOtp(phone.value);
      print('response: ${response}');

      if (response["success"] == true) {
        Get.snackbar("Success", response["message"]);

        Get.toNamed(
          AppRoutes.otp,
          arguments: {
            "mobile": phone.value,
            "isNewRider": response["isNewRider"] ?? false,
          },
        );
      } else {
        Get.snackbar("Error", response["message"] ?? "Something went wrong");
      }
    } catch (e) {
      Get.snackbar("Error", "Server error, please try again");
    } finally {
      isLoading.value = false;
    }
  }
}
