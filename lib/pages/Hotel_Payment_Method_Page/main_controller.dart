import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ta/configs/api_config.dart';
import 'package:mobile_ta/pages/Hotel_Payment_Method_Page/main_page.dart';
import 'package:mobile_ta/widgets/widget_error_screen.dart';

class PaymentController extends GetxController {
  var selectedPaymentMethod = 'Transfer Bank Mandiri'.obs;
  var selectedPaymentType = 'BCA'.obs;
  final ip = "http://192.168.18.7:3000";

  void setSelectedPaymentMethod(
      String paymentMethod, String paymentMethodType) {
    selectedPaymentMethod.value = paymentMethod;
    selectedPaymentType.value = paymentMethodType;
  }

  Future<void> confirmBook(List ids) async {
    final url = Uri.parse('$ip/hotels/bookings');
    final data = {"id": '${ids[1]}', "bookId": '${ids[0]}'};

    try {
      final response = await http.post(
        url,
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 201) {
        Get.to(() => const PaymentCompletedPage());
      }
    } catch (e) {
      return Get.to(() => const ErrorScreen(
            headMessage: "Kesalahan Server",
            message: "Server Dalam Masa Perbaikkan !",
          ));
    }
  }

  Future<void> cancelBook(String id) async {
    try {
      await deleteReq("bookings/$id");
      Get.back();
    } catch (e) {
      return Get.to(() => const ErrorScreen(
            headMessage: "Kesalahan Server",
            message: "Server Dalam Masa Perbaikkan !",
          ));
    }
  }
}
