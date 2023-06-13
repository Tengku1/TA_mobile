import 'package:get/get.dart';

class MainController extends GetxController {
  final selectedIndex = 0.obs;
  final currentRoute = Get.currentRoute;

  void onTabBtn(index) {
    switch (currentRoute) {
      case "/":
        selectedIndex.value = 0;
        break;
      case "/my-order":
        selectedIndex.value = 1;
        break;
      case "/profile":
        selectedIndex.value = 2;
        break;
    }
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
