import 'package:get/get.dart';
import 'package:mobile_ta/pages/Hotel_Rooms_List/main_page.dart';

class HotelListsController extends GetxController {
  final RxList<dynamic> hotels = <dynamic>[].obs;
  final sortByRate = true.obs;
  final sortByPrice = true.obs;

  sortByRatePressed(List hotels) {
    hotels.sort((a, b) => a['category']['description']['content']
        .substring(0, 1)
        .compareTo(b['category']['description']['content'].substring(0, 1)));
    if (!sortByRate.value) {
      hotels = hotels.reversed.toList();
    }
    update();
    return hotels;
  }

  sortByPricePressed(List hotels) {
    hotels.sort((a, b) => a['minRate'].compareTo(b['minRate']));
    if (!sortByPrice.value) {
      hotels = hotels.reversed.toList();
    }
    update();
    return hotels;
  }

  goToRoomList(
      List rooms, List images, List<Map<String, dynamic>> bookData) async {
    var roomList = [];
    var imageList = [];
    var sortedRooms = [];
    for (var image in images) {
      if (image['type']['description']['content'] == "Room") {
        if (image['roomCode'] != null) {
          imageList.add({
            "roomCode": image['roomCode'],
            "description": image['type']['description']['content'],
            "path": image['path']
          });
        }
      }
    }

    for (var room in rooms) {
      sortedRooms.add(room);
    }
    sortedRooms.sort((a, b) => a['code'].compareTo(b['code']));
    imageList.sort((a, b) => a['roomCode'].compareTo(b['roomCode']));
    for (var room in sortedRooms) {
      roomList.add({"images": getRoomImage(imageList, room), ...room});
      Get.to(() => HotelRoomsPage(roomList: roomList, bookData: bookData));
    }
  }

  getRoomImage(List images, room) {
    for (var image in images) {
      if (image['roomCode'] == room['code']) {
        return "http://photos.hotelbeds.com/giata/bigger/${image['path']}";
      }
    }
    return "https://images.pexels.com/photos/237371/pexels-photo-237371.jpeg?cs=srgb&dl=pexels-pixabay-237371.jpg&fm=jpg";
  }
}
