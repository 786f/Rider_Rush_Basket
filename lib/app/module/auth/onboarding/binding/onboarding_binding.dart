import 'package:get/get.dart';
import '../../document/controller/document_controller.dart';
import '../../workdetail/controller/work_detail_controller.dart';


class OnboardingBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WorkDetailsController());
    Get.lazyPut(() => DocumentsController());
  }
}
