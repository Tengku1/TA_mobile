import 'package:get/get.dart';

class HotelRoomController extends GetxController {
  final RxList<dynamic> hotels = <dynamic>[].obs;
  final sortByPrice = true.obs;
  final ip = "http://192.168.18.7:3000";

  sortByPricePressed(List hotels) {
    hotels.sort((a, b) => a['minRate'].compareTo(b['minRate']));
    if (!sortByPrice.value) {
      hotels = hotels.reversed.toList();
    }
    update();
    return hotels;
  }
}
