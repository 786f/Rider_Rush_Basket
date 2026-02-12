import 'package:get/get.dart';

class BottomNavController extends GetxController {
  RxInt currentIndex = 1.obs; // default = WebSocket screen

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
