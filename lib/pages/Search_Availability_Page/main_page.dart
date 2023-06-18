import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mobile_ta/pages/Search_Availability_Page/main_controller.dart';
import 'package:intl/intl.dart';
import 'package:range_slider_flutter/range_slider_flutter.dart';

class SearchAvailabilityPage extends StatelessWidget {
  final controller = Get.put(SearchAvailabilityController());
  final formKey = GlobalKey<FormState>();
  final errorMessage = "".obs;

  SearchAvailabilityPage({super.key});

  Future<void> _selectDate(BuildContext context,
      TextEditingController textEditingController, String checkInDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      textEditingController.text = formattedDate;

      if (textEditingController == controller.checkOutDateController) {
        final checkIn = DateFormat('yyyy-MM-dd').parse(checkInDate);
        final nextDay = checkIn.add(const Duration(days: 1));
        if (picked.isBefore(nextDay)) {
          textEditingController.text = DateFormat('yyyy-MM-dd').format(nextDay);
        }
      }
    }
  }

  Future<void> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Get.find<SearchAvailabilityController>().updateLocation(position);

    final location =
        '${placemarks[0].subAdministrativeArea}, ${placemarks[0].administrativeArea}';
    controller.locationController.text = location;
    controller.isLocationEnabled.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchAvailabilityController>(
      builder: (controller) => Scaffold(
          appBar: AppBar(
            title: const Text('Search Availability'),
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            determinePosition();
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: controller.locationController,
                              decoration: const InputDecoration(
                                  labelText: 'Location',
                                  hintText: "Current Location"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  errorMessage.value =
                                      'This Field Must Be Filled !';
                                  return 'This Field Must Be Filled !';
                                }
                                errorMessage.value = "";
                                return null;
                              },
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Obx(
                              () => Radio(
                                value: false,
                                groupValue: controller.isLocationEnabled.value,
                                onChanged: (value) {
                                  controller
                                      .toggleNearestLocation(value as bool);
                                },
                              ),
                            ),
                            const Text('Around Circuit'),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            _selectDate(
                                context, controller.checkInDateController, "");
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: controller.checkInDateController,
                              decoration: const InputDecoration(
                                  labelText: 'Check-In Date',
                                  hintText: "Check-in Date From Hotel"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  errorMessage.value =
                                      'This Field Must Be Filled !';
                                  return 'This Field Must Be Filled !';
                                }
                                errorMessage.value = "";
                                return null;
                              },
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _selectDate(
                                context,
                                controller.checkOutDateController,
                                controller.checkInDateController.text);
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: controller.checkOutDateController,
                              decoration: const InputDecoration(
                                  labelText: 'Check-Out Date',
                                  hintText: "Check-Out Date From Hotel"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  errorMessage.value =
                                      'This Field Must Be Filled !';
                                  return 'This Field Must Be Filled !';
                                }
                                errorMessage.value = "";
                                return null;
                              },
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: TextFormField(
                              controller: controller.minRateController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Min Rate',
                                  hintText: "Minimum Price For Hotel"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  errorMessage.value =
                                      'This Field Must Be Filled !';
                                  return 'This Field Must Be Filled !';
                                }
                                int quantity = int.parse(value);
                                if (quantity < 100000) {
                                  errorMessage.value =
                                      'Minimum Price For The Hotel Is IDR. 100.000 / \$10';
                                  return 'Minimum Price For The Hotel Is IDR. 100.000 / \$10';
                                }
                                errorMessage.value = "";
                                return null;
                              },
                            )),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: TextFormField(
                                  controller: controller.maxRateController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      labelText: 'Max Rate',
                                      hintText: "Maximum Price For Hotel"),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      errorMessage.value =
                                          'This Field Must Be Filled !';
                                      return 'This Field Must Be Filled !';
                                    }
                                    int quantity = int.parse(value);
                                    if (quantity < 250000) {
                                      errorMessage.value =
                                          'Minimum Price For The Hotel Is IDR. 100.000 / \$10';
                                      return 'Minimum Price For The Hotel Is IDR. 100.000 / \$10';
                                    }
                                    errorMessage.value = "";
                                    return null;
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Obx(
                              () => Text(
                                'Stars: ${controller.minStar.value.round()} - ${controller.maxStar.value.round()}',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Container(
                          width: MediaQuery.of(context)
                              .size
                              .width, // Mengatur lebar Container sesuai lebar layar
                          padding: const EdgeInsets.only(
                              left: 5,
                              right: 20,
                              top:
                                  10), // Memberikan padding horizontal jika diperlukan
                          child: RangeSliderFlutter(
                            // Properti-properti lain dari RangeSliderFlutter
                            values: [
                              controller.minStar.value,
                              controller.maxStar.value
                            ],
                            rangeSlider: true,
                            tooltip: RangeSliderFlutterTooltip(
                              alwaysShowTooltip: true,
                            ),
                            max: 5,
                            handlerHeight: 10,
                            trackBar: RangeSliderFlutterTrackBar(
                              activeTrackBarHeight: 5,
                              inactiveTrackBarHeight: 5,
                              activeTrackBar: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.red,
                              ),
                            ),
                            min: 1,
                            fontSize: 11,
                            textBackgroundColor: Colors.red,
                            onDragging: (handlerIndex, lowerValue, upperValue) {
                              controller
                                  .updateRangeValues([lowerValue, upperValue]);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      await controller.fetchAvailability();
                                    } else {
                                      errorMessage.value =
                                          "Please, Fill The Necessary Fields !";
                                    }
                                  },
                                  child: const Text('Submit'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    controller.resetForm();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red),
                                  child: const Text('Reset'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Obx(() {
                return controller.isLoading.value
                    ? Container(
                        color: Colors.black54,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16.0),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Please Wait ...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink();
              }),
            ],
          )),
    );
  }
}
