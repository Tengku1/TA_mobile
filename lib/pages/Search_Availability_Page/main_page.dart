import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mobile_ta/pages/Search_Availability_Page/main_controller.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

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
                                  hintText: "Berdasarkan Lokasi Sekarang"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  errorMessage.value =
                                      'Kolom Tidak Boleh Kosong';
                                  return 'Kolom Tidak Boleh Kosong';
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
                                context, controller.checkInDateController, "");
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: controller.checkInDateController,
                              decoration: const InputDecoration(
                                  labelText: 'Check-In Date',
                                  hintText: "Tanggal Masuk Ke Kamar Hotel"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  errorMessage.value =
                                      'Kolom Tidak Boleh Kosong';
                                  return 'Kolom Tidak Boleh Kosong';
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
                                  hintText: "Tanggal Keluar Dari Hotel"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  errorMessage.value =
                                      'Kolom Tidak Boleh Kosong';
                                  return 'Kolom Tidak Boleh Kosong';
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
                                  hintText: "Harga Terendah Dari Hotel"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  errorMessage.value =
                                      'Kolom Tidak Boleh Kosong';
                                  return 'Kolom Tidak Boleh Kosong';
                                }
                                int quantity = int.parse(value);
                                if (quantity < 100000) {
                                  errorMessage.value =
                                      'Harga Terendah Adalah 100.000';
                                  return 'Harga Terendah Adalah 100.000';
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
                                      hintText: "Harga Tertinggi Dari Hotel"),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      errorMessage.value =
                                          'Kolom Tidak Boleh Kosong';
                                      return 'Kolom Tidak Boleh Kosong';
                                    }
                                    int quantity = int.parse(value);
                                    if (quantity < 250000) {
                                      errorMessage.value =
                                          'Harga Terendah Adalah 100.000';
                                      return 'Harga Terendah Adalah 100.000';
                                    }
                                    errorMessage.value = "";
                                    return null;
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: TextFormField(
                              controller: controller.minCategoryController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Min Star',
                                  hintText: "Minimal Bintang Hotel (min : 1)"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  errorMessage.value =
                                      'Kolom Tidak Boleh Kosong';
                                  return 'Kolom Tidak Boleh Kosong';
                                }
                                int quantity = int.parse(value);
                                if (quantity < 1 || quantity > 5) {
                                  errorMessage.value =
                                      'Masukkan Angka Antara 1-5';
                                  return 'Masukkan Angka Antara 1-5';
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
                                  controller: controller.maxCategoryController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      labelText: 'Min Star',
                                      hintText:
                                          "Maksimal Bintang Hotel (mak : 5)"),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      errorMessage.value =
                                          'Kolom Tidak Boleh Kosong';
                                      return 'Kolom Tidak Boleh Kosong';
                                    }
                                    int quantity = int.parse(value);
                                    if (quantity < 1 || quantity > 5) {
                                      errorMessage.value =
                                          'Masukkan Angka Antara 1-5';
                                      return 'Masukkan Angka Antara 1-5';
                                    }
                                    errorMessage.value = "";
                                    return null;
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                        TextFormField(
                          controller: controller.roomFieldController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: 'Room',
                              hintText: "Jumlah Room Yang Dipesan"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              errorMessage.value = 'Kolom Tidak Boleh Kosong';
                              return 'Kolom Tidak Boleh Kosong';
                            }
                            int quantity = int.parse(value);
                            if (quantity < 1) {
                              errorMessage.value =
                                  'Ruangan Tidak Bisa Bernilai 0';
                              return 'Ruangan Tidak Bisa Bernilai 0';
                            }
                            errorMessage.value = "";
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: controller.adultFieldController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: 'Adult',
                              hintText: "Jumlah Orang Dewasa Pada 1 Kamar"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              errorMessage.value = 'Kolom Tidak Boleh Kosong';
                              return 'Kolom Tidak Boleh Kosong';
                            }
                            errorMessage.value = "";
                            return null;
                          },
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
                                          "Isi Kolom Yang Dibutuhkan !";
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
                                  'Mohon tunggu, kami lagi carikan hotel',
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
