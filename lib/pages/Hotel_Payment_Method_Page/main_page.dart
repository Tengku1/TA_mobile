import 'package:mobile_ta/pages/Hotel_Payment_Method_Page/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentMethodsPage extends StatelessWidget {
  final paymentController = Get.put(PaymentController());

  PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Bayar Sebelum - 04-06-2023',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Kode Pembayaran (BCA) : 014814957891305',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Obx(() => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          paymentController.selectedPaymentMethod.value,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showPaymentMethodBottomSheet(context);
                          },
                          child: const Text(
                            'Ganti',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(const PaymentCompletedPage());
        },
        label: const Text('Saya Sudah Bayar'),
      ),
      bottomNavigationBar: const BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Total : IDR 350.000',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showPaymentMethodBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Transfer Bank Mandiri'),
                onTap: () {
                  Get.back();
                  paymentController.setSelectedPaymentMethod(
                      'Transfer Bank Mandiri', 'Mandiri');
                },
              ),
              ListTile(
                title: const Text('Transfer Bank Bca'),
                onTap: () {
                  Get.back();
                  paymentController.setSelectedPaymentMethod(
                      'Transfer Bank Bca', 'BCA');
                },
              ),
              ListTile(
                title: const Text('Transfer Bank BRI'),
                onTap: () {
                  Get.back();
                  paymentController.setSelectedPaymentMethod(
                      'Transfer Bank BRI', 'BRI');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class PaymentCompletedPage extends StatelessWidget {
  const PaymentCompletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Hotel Berhasil Dipesan !",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.to("/");
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 6, 156, 156),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: const Text(
                    'Ke Beranda',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed("/my-order");
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 6, 156, 156),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: const Text(
                    'Ke Halaman My Order',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
