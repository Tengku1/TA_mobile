import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ta/widgets/widget_error_screen.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  final usernameController = TextEditingController();
  final pwdController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  var isLoading = false.obs;
  final ip = "http://192.168.18.7:3000";
  final usersData = {}.obs;

  void resetForm() {
    usernameController.text = "";
    pwdController.text = "";
  }

  Future<void> login() async {
    final url = Uri.parse('$ip/hotels/login');
    final data = {
      'email': emailController.text,
      'password': pwdController.text
    };

    try {
      if (usersData.isNotEmpty) {
        return Get.offAllNamed("/");
      }
      final response = await http.post(url,
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});

      final responseData = jsonDecode(response.body);
      usersData.value = responseData;
      return Get.toNamed("/");
    } catch (e) {
      return Get.to(() => ErrorScreen(
            headMessage: "Error",
            message: "{$e.message}",
          ));
    }
  }
}
