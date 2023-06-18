import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ta/main_controller.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ta/widgets/widget_error_screen.dart';

class ListHotelOrder extends StatelessWidget {
  ListHotelOrder({Key? key}) : super(key: key);
  final controller = Get.put(MainController());
  final ip = "http://192.168.18.7:3000";
  final data = [].obs;

  void fetchData() async {
    final url = Uri.parse('$ip/hotels/bookings/lists');
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      final responseData = jsonDecode(response.body);
      data.value = responseData;
      print(data[0]);
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

                    return GestureDetector(
                      onTap: () {},
                      child: Padding(
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
                                  ],
                                ),
                              ),
                            ],
                          ),
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
