import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobile_ta/pages/Hotel_Lists/main_controller.dart';

class HotelListPage extends StatelessWidget {
  final List<dynamic> hotels;

  const HotelListPage({Key? key, required this.hotels}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final RxInt visibleItemCount = 10.obs;
    final controller = Get.put(HotelListsController());

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (visibleItemCount.value < hotels.length) {
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
                      controller.sortByRate.value =
                          !controller.sortByRate.value;
                      if (controller.sortByPrice.value) {
                        controller.sortByPrice.value = false;
                      }
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    label: const Text('Rating'),
                    icon: const Icon(Icons.star_border),
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton.icon(
                    onPressed: () {
                      controller.sortByPrice.value =
                          !controller.sortByPrice.value;
                      if (controller.sortByRate.value) {
                        controller.sortByRate.value = false;
                      }
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
                  List<dynamic> sortedHotels = controller.sortHotels(hotels);
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
                      final hotel = sortedHotels[index];
                      final List<dynamic> images = hotel['images'];
                      final String imagePath =
                          images.isNotEmpty ? images[0]['path'] : '';

                      return GestureDetector(
                        onTap: () {
                          Get.to(() => HotelDetailPage(hotel: hotel));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 5.0,
                          ),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (imagePath.isNotEmpty)
                                  Image.network(
                                    'http://photos.hotelbeds.com/giata/bigger/$imagePath',
                                    width: double.infinity,
                                    height: 180,
                                    fit: BoxFit.cover,
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        hotel['name']['content'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                          '${hotel['zone']['name']}, ${hotel['destination']['name']['content']}'),
                                      Text(
                                          'Type: ${hotel['category']['description']['content']}'),
                                      Text(
                                          'Price: ${hotel['minRate']} - ${hotel['maxRate']} /night(s)'),
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

class HotelDetailPage extends StatelessWidget {
  final dynamic hotel;

  const HotelDetailPage({Key? key, required this.hotel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HotelListsController());
    final bookData = [
      {
        "check_in": hotel['check_in'],
        "check_out": hotel['check_out'],
        "zoneName": hotel['zone']['name'],
        "categoryName": hotel['category']['description']['content'],
        "destinationName": hotel['destination']['name']['content'],
        "latitude": hotel['coordinates']['latitude'],
        "longitude": hotel['coordinates']['longitude'],
        "hotelCode": hotel['code'],
        "hotelName": hotel['name']['content']
      }
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: CarouselSlider.builder(
                itemCount: hotel['images'].length,
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  return Image.network(
                    'http://photos.hotelbeds.com/giata/bigger/${hotel['images'][index]['path']}',
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  );
                },
                options: CarouselOptions(
                  viewportFraction: 1,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${hotel['name']['content']}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  hotel['category']['code'].contains('EST')
                      ? RatingBarIndicator(
                          rating: double.parse(
                              hotel['category']['code'].substring(0, 1)),
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 14.0,
                          direction: Axis.horizontal,
                        )
                      : Text(
                          '${hotel['category']['code']}',
                          style: const TextStyle(fontSize: 12),
                        ),
                  const SizedBox(height: 10),
                  Text(
                    'Price Range : ${hotel['minRate']} - ${hotel['maxRate']} /night(s)',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 100),
                    child: Text(
                      hotel['description']['content'],
                      style: const TextStyle(fontSize: 12),
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Address',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${hotel['address']['content']}, ${hotel['zone']['name']}, ${hotel['destination']['name']['content']}, ${hotel['postalCode']}',
                    style: const TextStyle(fontSize: 12),
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: const BoxDecoration(
                        border: Border.symmetric(
                            horizontal: BorderSide(
                                width: 2,
                                color: Color.fromARGB(113, 0, 0, 0)))),
                    child: Center(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: GestureDetector(
                            onTap: () {
                              controller.goToRoomList(
                                  hotel['room_availability'],
                                  hotel['images'],
                                  bookData);
                            },
                            child: const Text(
                              'Show Rooms',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(157, 68, 137, 255)),
                            ),
                          )),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'More Info',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  hotel['email'] != null
                      ? Text(
                          'Email : ${hotel['email'].toLowerCase()}',
                          style: const TextStyle(fontSize: 12),
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                        )
                      : const Text(
                          'Email : -',
                          style: TextStyle(fontSize: 12),
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                        ),
                  const SizedBox(height: 5),
                  hotel['web'] != null
                      ? Text(
                          'Website : ${hotel['web']}',
                          style: const TextStyle(fontSize: 12),
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        )
                      : const Text(
                          'Website : -',
                          style: TextStyle(fontSize: 12),
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                  const SizedBox(height: 5),
                  hotel['phones'] != null
                      ? Text(
                          'Phones : ${hotel['phones'][0]['phoneNumber']}',
                          style: const TextStyle(fontSize: 12),
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                        )
                      : const Text(
                          'Phones : -',
                          style: TextStyle(fontSize: 12),
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
