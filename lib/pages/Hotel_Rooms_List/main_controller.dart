import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mobile_ta/configs/api_config.dart';
import 'package:mobile_ta/pages/Hotel_Payment_Method_Page/main_page.dart';
import 'package:mobile_ta/pages/auth/auth_controller.dart';
import 'package:mobile_ta/widgets/widget_error_screen.dart';

class HotelRoomController extends GetxController {
  final RxList<dynamic> hotels = <dynamic>[].obs;
  final sortByPrice = true.obs;
  TextEditingController remarksController = TextEditingController();
  final authController = Get.put(AuthController());

  sortByPricePressed(List hotels) {
    hotels.sort((a, b) => a['minRate'].compareTo(b['minRate']));
    if (!sortByPrice.value) {
      hotels = hotels.reversed.toList();
    }
    update();
    return hotels;
  }

  Future<void> goToPaymentPage(room, List bookData) async {
    final book = bookData[0];
    final holder = {
      "name": authController.usersData['name'],
      "surname": authController.usersData['surname']
    };
    final rooms = {
      "rateKey": room['rates'][0]['rateKey'],
      "roomCode": room['code'],
      "roomName": '${book['roomName']}',
      "paxes": {
        "roomId": 1,
        "type": "AD",
        "name": "${authController.usersData['name']}",
        "surname": "${authController.usersData['surname']}"
      }
    };
    final user = '${authController.usersData['id']}';
    final phone = authController.usersData['telephone'];
    final email = authController.usersData['email'];
    final checkIn = '${book['check_in']}';
    final checkOut = '${book['check_out']}';
    final hotelCode = book['hotelCode'];
    final hotelName = '${book['hotelName']}';
    final zoneName = '${book['zoneName']}';
    final categoryName = '${book['categoryName']}';
    final destinationName = '${book['destinationName']}';
    final latitude = '${book['latitude']}';
    final longitude = '${book['longitude']}';
    final remark = remarksController.text.isEmpty ? '' : remarksController.text;
    final pendingAmount = room['rates'][0]['net'];

    final data = {
      'user': user,
      'phone': phone,
      'email': email,
      'holder': holder,
      "check_in": checkIn,
      "check_out": checkOut,
      "hotelCode": hotelCode,
      "hotelName": hotelName,
      "zoneName": zoneName,
      "categoryName": categoryName,
      "destinationName": destinationName,
      'rooms': rooms,
      "latitude": latitude,
      "longitude": longitude,
      "remark": remark,
      "pending_amount": pendingAmount,
      "clientReference": "TUGAS_AKHIR",
      "image": '${book['image']}'
    };

    try {
      final response = await postReq("bookings/database", data);
      final ids = [
        response['bookId'],
        response['bookHotelId'],
      ];

      if (response['statusCode'] == 201) {
        Get.to(() => PaymentMethodsPage(room: room, ids: ids));
      }
    } catch (e) {
      return Get.to(() => const ErrorScreen(
            headMessage: "Kesalahan Server",
            message: "Server Dalam Masa Perbaikkan !",
          ));
    }
  }
}
