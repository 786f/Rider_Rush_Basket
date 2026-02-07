// import 'package:get/get.dart';
// import '../../../../routes/app_routes.dart';
//
//
// class SplashController extends GetxController {
//   @override
//   void onInit() {
//     super.onInit();
//     goToNext();
//   }
//
//   void goToNext() async {
//     await Future.delayed(const Duration(seconds: 2));
//     Get.offNamed(AppRoutes.login);
//   }
// }
//
//

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../routes/app_routes.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    goToNext();
  }

  void goToNext() async {
    await Future.delayed(const Duration(seconds: 2));

    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    String? token = prefs.getString("auth_token");

    if (token != null && token.isNotEmpty) {
      // Token present → Job page
      Get.offNamed(AppRoutes.riderJobList);
    } else {
      // Token not present → Login
      Get.offNamed(AppRoutes.login);
    }
  }
}
