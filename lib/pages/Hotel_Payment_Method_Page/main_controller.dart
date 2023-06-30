import 'package:get/get.dart';
import 'package:mobile_ta/configs/api_config.dart';
import 'package:mobile_ta/pages/Hotel_Payment_Method_Page/main_page.dart';
import 'package:mobile_ta/widgets/widget_error_screen.dart';

class PaymentController extends GetxController {
  var selectedPaymentMethod = 'Transfer Bank Mandiri'.obs;
  var selectedPaymentType = 'BCA'.obs;

  void setSelectedPaymentMethod(
      String paymentMethod, String paymentMethodType) {
    selectedPaymentMethod.value = paymentMethod;
    selectedPaymentType.value = paymentMethodType;
  }

  Future<void> confirmBook(List ids) async {
    final data = {"id": '${ids[1]}', "bookId": '${ids[0]}'};

    try {
      final response = await postReq("bookings", data);
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
