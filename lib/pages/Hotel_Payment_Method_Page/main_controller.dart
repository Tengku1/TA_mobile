import 'package:get/get.dart';

class PaymentController extends GetxController {
  var selectedPaymentMethod = 'Transfer Bank Mandiri'.obs;
  var selectedPaymentType = 'BCA'.obs;

  void setSelectedPaymentMethod(
      String paymentMethod, String paymentMethodType) {
    selectedPaymentMethod.value = paymentMethod;
    selectedPaymentType.value = paymentMethodType;
  }
}
