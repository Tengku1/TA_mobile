import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ta/main_controller.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ta/widgets/widget_error_screen.dart';

class ListHotelOrder extends StatelessWidget {
  ListHotelOrder({Key? key}) : super(key: key);
  final menuController = Get.put(MainController());
  final ip = "http://192.168.18.7:3000";

  Future<dynamic> fetchData() async {
    final url = Uri.parse('$ip/hotels/bookings/availability');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      return jsonDecode(response.body);
    } catch (e) {
      Get.to(() => const ErrorScreen(
            headMessage: "Kesalahan Server",
            message: "Server Dalam Masa Perbaikkan !",
          ));
      return null; // Tambahkan return null untuk kasus error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Hotel Order Lists",
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError || snapshot.data == null) {
              return const ErrorScreen(
                headMessage: "Kesalahan Server",
                message: "Server Dalam Masa Perbaikkan !",
              );
            } else {
              final orders = snapshot.data;
              if (orders.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "You Have No Orders",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    // Ubah sesuai dengan item yang ingin ditampilkan
                    return GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            title: Text(orders[index]['title']),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }
}
