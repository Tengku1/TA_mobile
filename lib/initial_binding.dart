import 'package:mobile_ta/pages/Search_Availability_Page/main_controller.dart';

import 'package:get/get.dart';

class InitialBinding implements Bindings {
  @override
  Future<void> dependencies() async {
    Get.put(SearchAvailabilityController());
  }
}
