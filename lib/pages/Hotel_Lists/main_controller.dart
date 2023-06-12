// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ta/pages/Hotel_Rooms/main_page.dart';

class HotelListsController extends GetxController {
  final RxList<dynamic> hotels = <dynamic>[].obs;

  void filterByType() {
    // Implement your logic to filter hotels by type
    // You can access the 'hotels' list using the 'hotels' variable
  }

  void filterByPrice() {
    // Implement your logic to filter hotels by price
    // You can access the 'hotels' list using the 'hotels' variable
  }

  Future<void> getRoomDetail(Map<String, dynamic> room, imagePath) async {
    Get.to(HotelRoomsPage(
        rooms: room,
        image: imagePath ??
            "https://media.istockphoto.com/id/627892060/id/foto/suite-kamar-hotel-dengan-pemandangan.jpg?b=1&s=612x612&w=0&k=20&c=0hOd00tRBIbInc09jgREGwem9nvzBX9gi2JuZcdUWUM="));
  }

  getRoomImage(List images, roomCode) {
    for (var image in images) {
      if (image['type']['description']['content'] == "Room") {
        if (image['roomCode'] == roomCode) {
          return "http://photos.hotelbeds.com/giata/bigger/${image['path']}";
        }
      }
    }
  }
}
