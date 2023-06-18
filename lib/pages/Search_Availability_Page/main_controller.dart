import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:mobile_ta/pages/Hotel_Lists/main_page.dart';
import 'package:mobile_ta/utils/currency_format.dart';
import 'package:mobile_ta/widgets/widget_error_screen.dart';

class SearchAvailabilityController extends GetxController {
  final locationController = TextEditingController();
  final checkInDateController = TextEditingController();
  final checkOutDateController = TextEditingController();
  final minRateController = TextEditingController();
  final maxRateController = TextEditingController();
  final isLocationEnabled = true.obs;
  var latitude = 0.0;
  var longitude = 0.0;
  var isLoading = false.obs;
  final ip = "http://192.168.18.7:3000";
  var minStar = 1.0.obs;
  var maxStar = 5.0.obs;

  void updateRangeValues(List<double> values) {
    minStar.value = values[0];
    maxStar.value = values[1];
  }

  void updateLocation(Position position) {
    latitude = double.parse(position.latitude.toString());
    longitude = double.parse(position.longitude.toString());
  }

  Future<void> toggleNearestLocation(bool value) async {
    isLocationEnabled.value = value;
    latitude = -8.5995156;
    longitude = 116.155;
    List<Placemark> placemarks = await placemarkFromCoordinates(
      latitude,
      longitude,
    );
    locationController.text =
        '${placemarks[0].subAdministrativeArea}, ${placemarks[0].administrativeArea}';
  }

  bool isCheckOutMoreThan30Days() {
    DateTime checkInDate = DateTime.parse(checkInDateController.text);
    DateTime checkOutDate = DateTime.parse(checkOutDateController.text);

    // Menghitung selisih antara dua tanggal
    Duration difference = checkOutDate.difference(checkInDate);

    // Memeriksa apakah selisih lebih dari 30 hari
    if (difference.inDays > 30) {
      return true;
    } else {
      return false;
    }
  }

  void resetForm() {
    locationController.text = "";
    checkInDateController.text = "";
    checkOutDateController.text = "";
  }

  Future<void> fetchAvailability() async {
    final url = Uri.parse('$ip/hotels/bookings/availability');

    final stay = {
      'checkIn': checkInDateController.text,
      'checkOut': checkOutDateController.text,
    };

    final occupancies = [
      {
        'rooms': 1,
        'adults': 1,
        'children': 0,
      }
    ];

    final geolocation = {
      'latitude': latitude,
      'longitude': longitude,
      'radius': 20,
      'unit': 'km',
    };

    final filter = {
      'minRate': int.parse(minRateController.text),
      'maxRate': int.parse(maxRateController.text),
      'minCategory': minStar.value.toInt(),
      'maxCategory': maxStar.value.toInt(),
    };

    const offset = 0;

    final data = {
      'stay': stay,
      'occupancies': occupancies,
      'geolocation': geolocation,
      'filter': filter,
      'offset': offset,
    };

    try {
      isLoading.value = true;
      final response = await http.post(
        url,
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      final availabilityHotel = jsonDecode(response.body);
      List<dynamic> hotelDetails = [];

      for (var hotel in availabilityHotel) {
        final id = hotel['code'];
        final url = Uri.parse('$ip/hotels/$id?language=IND');
        final detailResponse = await http.get(url);
        final minRate =
            CurrencyFormat.convertToIdr(double.parse(hotel['minRate']));
        final maxRate =
            CurrencyFormat.convertToIdr(double.parse(hotel['maxRate']));
        if (detailResponse.statusCode == 200) {
          var detailData = jsonDecode(detailResponse.body);
          hotelDetails.add({
            "minRate": minRate,
            "maxRate": maxRate,
            "check_in": stay['checkIn'],
            "check_out": stay['checkOut'],
            "room_availability": hotel['rooms'],
            ...detailData['hotel']
          });
        }
      }
      if (hotelDetails.isEmpty) {
        Get.to(() => const ErrorScreen(
              headMessage:
                  "Tidak Ditemukan Hotel Dengan Data Yang Telah Diberikan",
              message: "Hotel Tidak Ditemukan",
            ));
      } else {
        Get.to(() => HotelListPage(hotels: hotelDetails));
      }
    } catch (e) {
      return Get.to(() => const ErrorScreen(
            headMessage: "Kesalahan Server",
            message: "Server Dalam Masa Perbaikkan !",
          ));
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    locationController.dispose();
    checkInDateController.dispose();
    checkOutDateController.dispose();
    minRateController.dispose();
    super.onClose();
  }
}
