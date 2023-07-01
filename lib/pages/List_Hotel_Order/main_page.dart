import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ta/configs/api_config.dart';
import 'package:mobile_ta/main_controller.dart';
import 'package:mobile_ta/widgets/widget_error_screen.dart';

class ListHotelOrder extends StatelessWidget {
  ListHotelOrder({Key? key}) : super(key: key);
  final controller = Get.put(MainController());
  final data = [].obs;

  void fetchData() async {
    try {
      final response = await getReq("bookings/lists");
      final responseData = jsonDecode(response.body);
      data.value = responseData;
    } catch (e) {
      Get.to(() => const ErrorScreen(
            headMessage: "Kesalahan Server",
            message: "Server Dalam Masa Perbaikkan !",
          ));
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final RxInt visibleItemCount = 10.obs;
    fetchData();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (visibleItemCount.value < data.length) {
          visibleItemCount.value += 1;
        }
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Hotel Order Lists",
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Obx(
          () => data.isEmpty
              ? const Center(
                  child: Text(
                    "You Have No Orders",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  controller: scrollController,
                  itemCount: visibleItemCount.value < data.length
                      ? visibleItemCount.value + 1
                      : data.length,
                  itemBuilder: (context, index) {
                    if (index == visibleItemCount.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final hotel = data[index];
                    final images = hotel['image'];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 5.0),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (images.isNotEmpty)
                              Image.network(
                                '$images',
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hotel['hotel'][0]['name'],
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Check-In : ${hotel['hotel'][0]['check_in']}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    'Check-Out : ${hotel['hotel'][0]['check_out']}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    'Payment Status : ${hotel['status']}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  hotel['status'] == 'PENDING'
                                      ? Row(
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {},
                                              child: const Text(
                                                'Go To Payment',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            ElevatedButton(
                                              onPressed: () async {
                                                await deleteReq(
                                                    "bookings/${hotel['booking_reference_code']}");
                                                data.refresh();
                                                Get.snackbar('Success',
                                                    'Booking cancelled successfully');
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red),
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            )
                                          ],
                                        )
                                      : const SizedBox(height: 0)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            selectedItemColor: Colors.blue,
            onTap: (index) => controller.onTabBtn(index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_hotel_rounded),
                label: 'Hotel Order',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          )),
    );
  }
}
