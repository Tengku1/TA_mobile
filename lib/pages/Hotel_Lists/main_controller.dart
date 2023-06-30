import 'package:get/get.dart';
import 'package:mobile_ta/pages/Hotel_Rooms_List/main_page.dart';

class HotelListsController extends GetxController {
  final RxList<dynamic> hotels = <dynamic>[].obs;
  final RxBool sortByRate = true.obs;
  final RxBool sortByPrice = true.obs;

  List<dynamic> sortHotels(List hotels) {
    List<dynamic> sortedHotels = [...hotels];

    if (sortByRate.value) {
      sortedHotels.sort((a, b) {
        final aCategory = a['category']['description']['content'];
        final bCategory = b['category']['description']['content'];

        if (aCategory is String && bCategory is String) {
          return bCategory.substring(0, 1).compareTo(aCategory.substring(0, 1));
        } else {
          return 0;
        }
      });
    } else if (sortByPrice.value) {
      sortedHotels.sort((a, b) {
        final aMinRate = a['minRate'];
        final bMinRate = b['minRate'];

        if (aMinRate is num && bMinRate is num) {
          return aMinRate.compareTo(bMinRate);
        } else {
          return 0;
        }
      });
    }

    return sortedHotels;
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
