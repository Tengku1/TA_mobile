import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ta/configs/api_config.dart';
import 'package:mobile_ta/widgets/widget_error_screen.dart';
import 'dart:convert';

class AuthController extends GetxController {
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final pwdController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  var isLoading = false.obs;
  final usersData = {}.obs;
  final isLogggIn = false.obs;

  void resetForm() {
    nameController.text = "";
    surnameController.text = "";
    phoneController.text = "";
    emailController.text = "";
    pwdController.text = "";
  }

  Future<void> login() async {
    final data = {
      'email': emailController.text,
      'password': pwdController.text
    };

    try {
      final response = await postReq("login", data);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 400) {
        Get.snackbar('Warning', 'Account Not Found');
        return;
      }
      usersData.value = responseData;
      isLogggIn.value = true;
      return Get.offAllNamed("/");
    } catch (e) {
      return Get.to(() => ErrorScreen(
            headMessage: "Error",
            message: "{$e.message}",
          ));
    }
  }

  Future<void> register() async {
    final data = {
      'email': emailController.text,
      'password': pwdController.text,
      'name': nameController.text,
      'surname': surnameController.text,
      'telephone': phoneController.text
    };

    try {
      if (usersData.isNotEmpty) {
        return Get.offAllNamed("/");
      }
      final response = await postReq("register", data);
      usersData.value = response;
      Get.offAndToNamed("/");
    } catch (e) {
      return Get.to(() => ErrorScreen(
            headMessage: "Error",
            message: "{$e.message}",
          ));
    }
  }
}
