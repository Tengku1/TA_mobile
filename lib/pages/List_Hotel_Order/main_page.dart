import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ta/configs/api_config.dart';
import 'package:mobile_ta/main_controller.dart';
import 'package:mobile_ta/pages/Hotel_Payment_Method_Page/main_page.dart';
import 'package:mobile_ta/widgets/widget_error_screen.dart';

class ListHotelOrder extends StatelessWidget {
  ListHotelOrder({Key? key}) : super(key: key);
  final homeController = Get.put(MainController());
  final data = RxList<dynamic>([]);
  final RxInt visibleItemCount = 10.obs;

  void fetchData() async {
    try {
      final response = await getReq("order/lists");
      final responseData = jsonDecode(response.body);
      data.assignAll(responseData);
      data.listen((_) {
        if (visibleItemCount.value > data.length) {
          visibleItemCount.value = data.length;
        }
      });
    } catch (e) {
      Get.to(() => const ErrorScreen(
            headMessage: "Kesalahan Server",
            message: "Server Dalam Masa Perbaikkan !",
          ));
      return null;
    }
  }

  void sortOrders(int index) async {
    final removedData = await getReq("order/${data[index]['id']}");
    final orderDetail = jsonDecode(removedData.body);
    data.removeAt(index);
    data.insert(0, orderDetail[0]);
    if (visibleItemCount.value > data.length) {
      visibleItemCount.value = data.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
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
                    final List ids = [hotel['id'], hotel['hotel_id']];
                    final rooms = jsonDecode(hotel['rooms']);
                    final room = {
                      'rates': [
                        {
                          'net': hotel['pending_amount'],
                          'cancellationPolicies': [
                            {'from': hotel['cancellationPolicies']}
                          ],
                        }
                      ],
                      'name': rooms['roomName'],
                    };

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
                            Image.network(
                              '${hotel['image']}',
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
                                    hotel['hotel_name'],
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Check-In : ${hotel['check_in']}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    'Check-Out : ${hotel['check_out']}',
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
                                              onPressed: () {
                                                Get.to(() => PaymentMethodsPage(
                                                    room: room, ids: ids));
                                                sortOrders(index);
                                              },
                                              child: const Text(
                                                'Go To Payment',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            ElevatedButton(
                                              onPressed: () async {
                                                await deleteReq(
                                                    "bookings/${hotel['id']}");
                                                sortOrders(index);
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
            currentIndex: homeController.selectedIndex.value,
            selectedItemColor: Colors.blue,
            onTap: (index) => homeController.onTabBtn(index),
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
