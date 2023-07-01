import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ta/pages/Hotel_Rooms_List/main_controller.dart';
import 'package:mobile_ta/utils/currency_format.dart';

class HotelRoomsPage extends StatelessWidget {
  final List<dynamic> roomList;
  final List<Map<String, dynamic>> bookData;

  const HotelRoomsPage(
      {super.key, required this.roomList, required this.bookData});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final RxInt visibleItemCount = 5.obs;
    final controller = Get.put(HotelRoomController());

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (visibleItemCount.value < roomList.length) {
          visibleItemCount.value += 1;
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel List'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      controller.sortByPrice.value =
                          !controller.sortByPrice.value;
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    label: const Text('Price'),
                    icon: const Icon(Icons.price_change_rounded),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(
                () {
                  List<dynamic> sortedHotels = controller.sortHotels(roomList);
                  return ListView.builder(
                    controller: scrollController,
                    itemCount: visibleItemCount.value < sortedHotels.length
                        ? visibleItemCount.value + 1
                        : sortedHotels.length,
                    itemBuilder: (context, index) {
                      if (index == visibleItemCount.value) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final hotel = sortedHotels.isEmpty
                          ? roomList[index]
                          : sortedHotels[index];
                      final images = roomList[index]['images'];

                      return GestureDetector(
                        onTap: () {
                          Get.to(() => RoomDetailPage(
                              room: hotel, image: images, bookData: bookData));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  images,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        hotel['name'],
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Price : ${CurrencyFormat.convertToIdr(double.parse(hotel['rates'][0]['net']))}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        'Board : ${hotel['rates'][0]['boardName']}',
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoomDetailPage extends StatelessWidget {
  final dynamic room;
  final dynamic image;
  final List<Map<String, dynamic>> bookData;

  const RoomDetailPage(
      {Key? key,
      required this.room,
      required this.image,
      required this.bookData})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    bookData[0].addAll({"roomName": room['name']});
    bookData[0].addAll({"image": image});
    final controller = Get.put(HotelRoomController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Image.network(
                  '$image',
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                )),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${room['name']}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Price : ${CurrencyFormat.convertToIdr(double.parse(room['rates'][0]['net']))} /night(s)',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Board : ${room['rates'][0]['boardName']}',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Room Capacities',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Adults : ${room['rates'][0]['adults']}',
                    style: const TextStyle(fontSize: 12),
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Children : ${room['rates'][0]['children']}',
                    style: const TextStyle(fontSize: 12),
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Cancellation Policies',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Amount : ${CurrencyFormat.convertToIdr(double.parse(room['rates'][0]['cancellationPolicies'][0]['amount']))}',
                    style: const TextStyle(fontSize: 12),
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'From : ${room['rates'][0]['cancellationPolicies'][0]['from']}',
                    style: const TextStyle(fontSize: 12),
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Remarks',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Add some remarks ...',
                      ),
                      controller: controller.remarksController),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller.goToPaymentPage(room, bookData);
        },
        label: const Text('Book Now'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Total: ${CurrencyFormat.convertToIdr(double.parse(room['rates'][0]['net']))} /night(s)',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
