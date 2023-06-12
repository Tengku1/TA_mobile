import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'main_controller.dart';
import 'package:mobile_ta/widgets/widget_empty_screen.dart';

class HotelListPage extends StatelessWidget {
  final List<dynamic> hotels;

  const HotelListPage({Key? key, required this.hotels}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final RxInt visibleItemCount = 10.obs;

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
        child: Obx(
          () => ListView.builder(
            controller: scrollController,
            itemCount: visibleItemCount.value < hotels.length
                ? visibleItemCount.value + 1
                : hotels.length,
            itemBuilder: (context, index) {
              if (index == visibleItemCount.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final hotel = hotels[index];
              final List<dynamic> images = hotel['images'];
              final String imagePath =
                  images.isNotEmpty ? images[0]['path'] : '';

              return GestureDetector(
                onTap: () {
                  Get.to(() => HotelDetailPage(hotel: hotel));
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
                        if (imagePath.isNotEmpty)
                          Image.network(
                            'http://photos.hotelbeds.com/giata/bigger/$imagePath',
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
                                hotel['name']['content'],
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                  '${hotel['zone']['name']}, ${hotel['destination']['name']['content']}'),
                              Text(
                                  'Type: ${hotel['category']['description']['content']}'),
                              Text(
                                  'Harga: ${hotel['minRate']} - ${hotel['maxRate']}'),
                              const SizedBox(height: 10),
                              Text(
                                  '${hotel['description']['content'].substring(0, 200)} ...',
                                  textAlign: TextAlign.justify),
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
    );
  }
}

class HotelDetailPage extends StatefulWidget {
  final dynamic hotel;

  const HotelDetailPage({Key? key, required this.hotel}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HotelDetailPageState createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  final ScrollController scrollController = ScrollController();
  final RxInt visibleItemCount = 10.obs;
  final controller = Get.put(HotelListsController());

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (visibleItemCount.value < widget.hotel['rooms'].length) {
          visibleItemCount.value += 1;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> rooms = widget.hotel['rooms'];

    return rooms.isEmpty
        ? const EmptyScreen(
            message:
                "Hotel ini sedang dalam renovasi atau kamar sudah penuh semua",
            headMessage: "Maaf! Kamar Kosong :(",
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(widget.hotel['name']['content']),
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Obx(
                () => ListView.builder(
                  controller: scrollController,
                  itemCount: visibleItemCount.value < rooms.length
                      ? visibleItemCount.value + 1
                      : rooms.length,
                  itemBuilder: (context, index) {
                    if (index == visibleItemCount.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final room = rooms[index];
                    final List<dynamic> images = widget.hotel['images'];
                    final String imagePath = controller.getRoomImage(
                            images, room['roomCode']) ??
                        "https://media.istockphoto.com/id/627892060/id/foto/suite-kamar-hotel-dengan-pemandangan.jpg?b=1&s=612x612&w=0&k=20&c=0hOd00tRBIbInc09jgREGwem9nvzBX9gi2JuZcdUWUM=";

                    return GestureDetector(
                      onTap: () async {
                        await controller.getRoomDetail(room, imagePath);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (imagePath.isNotEmpty)
                                      Image.network(
                                        imagePath,
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            room['description'],
                                            style: const TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque sit amet risus risus. Aenean aliquam sapien purus, in accumsan mauris ultrices in.'),
                                        ],
                                      ),
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
          );
  }
}
