import 'package:get/get.dart';

import '../../personal/personal_info_controller.dart';
import '../controller/documents_controller.dart';
import '../controller/login_controller.dart';
import '../controller/work_details_controller.dart';


class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => PersonalInfoController());
    Get.lazyPut(() => DocumentsController());
    Get.lazyPut(() => WorkDetailsController());
  }
}
