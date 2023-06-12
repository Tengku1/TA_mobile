import 'package:get/get.dart';

class MainController extends GetxController {
  final selectedIndex = 0.obs;

  void onTabBtn(index) {
    selectedIndex.value = index;
    switch (index) {
      case 0:
        Get.toNamed("/");
        break;
      case 1:
        Get.toNamed("/my-order");
        break;
      case 2:
        Get.toNamed("/profile");
        break;
    }
  }
}
