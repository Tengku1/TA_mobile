import 'package:mobile_ta/pages/Hotel_Payment_Method_Page/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ta/utils/currency_format.dart';

class PaymentMethodsPage extends StatelessWidget {
  final controller = Get.put(PaymentController());
  final List ids;
  final dynamic room;

  PaymentMethodsPage({super.key, required this.room, required this.ids});

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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${room['name']}',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Bayar Sebelum - ${room['rates'][0]['cancellationPolicies'][0]['from']}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.selectedPaymentMethod.value,
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
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                controller.cancelBook(ids[0]);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: const Text(
                                'Batalkan',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        )
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
          controller.confirmBook(ids);
        },
        label: const Text('Saya Sudah Bayar'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Total : ${CurrencyFormat.convertToIdr(double.parse(room['rates'][0]['net']))}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  controller.setSelectedPaymentMethod(
                      'Transfer Bank Mandiri', 'Mandiri');
                },
              ),
              ListTile(
                title: const Text('Transfer Bank Bca'),
                onTap: () {
                  Get.back();
                  controller.setSelectedPaymentMethod(
                      'Transfer Bank Bca', 'BCA');
                },
              ),
              ListTile(
                title: const Text('Transfer Bank BRI'),
                onTap: () {
                  Get.back();
                  controller.setSelectedPaymentMethod(
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
