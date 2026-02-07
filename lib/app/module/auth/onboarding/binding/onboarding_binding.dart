import 'package:get/get.dart';
import '../../login/controller/documents_controller.dart';
import '../../login/controller/work_details_controller.dart';
import '../../personal/personal_info_controller.dart';


class OnboardingBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WorkDetailsController());
    Get.lazyPut(() => DocumentsController());
    Get.lazyPut(() => PersonalInfoController());
  }
}
