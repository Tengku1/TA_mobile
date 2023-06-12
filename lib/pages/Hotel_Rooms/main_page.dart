import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HotelRoomsPage extends StatelessWidget {
  final Map<String, dynamic> rooms;
  final String image;

  const HotelRoomsPage({Key? key, required this.rooms, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> roomFacilities = rooms['roomFacilities'];
    List<dynamic> limitedRoomFacilities = roomFacilities.sublist(0, 4);

    return Scaffold(
      appBar: AppBar(
        title: Text("${rooms['description']}"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Image.network(
                image,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                rooms['description'],
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque sit amet risus risus. Aenean aliquam sapien purus, in accumsan mauris ultrices in.",
                style: TextStyle(fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Fasilitas:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              itemCount: limitedRoomFacilities.length,
              separatorBuilder: (context, index) => const Divider(
                color: Colors.white,
              ),
              itemBuilder: (context, index) {
                var facility = limitedRoomFacilities[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    '- ${facility['description']['content']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed("/hotel-payment-methods");
        },
        label: const Text('Book Now'),
      ),
      bottomNavigationBar: const BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Harga Kamar: Rp. 350K per/malam',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
