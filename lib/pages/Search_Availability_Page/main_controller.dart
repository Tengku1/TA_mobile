import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mobile_ta/configs/api_config.dart';

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

  bool isCheckOutMoreThan30Days() {
    DateTime checkInDate = DateTime.parse(checkInDateController.text);
    DateTime checkOutDate = DateTime.parse(checkOutDateController.text);

    Duration difference = checkOutDate.difference(checkInDate);

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

  Future<void> fetchAvailability() async {
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
      final availabilityHotel = await postReq('bookings/availability', data);
      List<dynamic> hotelDetails = [];

      for (var hotel in availabilityHotel) {
        final id = hotel['code'];
        final detailResponse = await getReq("$id?language=IND");
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
    checkInDateController.dispose();
    checkOutDateController.dispose();
    super.onClose();
  }
}
