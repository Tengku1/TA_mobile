import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ta/pages/auth/auth_controller.dart';
import 'package:mobile_ta/routes/route_paths.dart';

class AuthMiddleware extends GetMiddleware {
  final controller = Get.put(AuthController());

  @override
  RouteSettings? redirect(String? route) {
    if (!isUserLoggedIn()) {
      return const RouteSettings(name: RoutePaths.LOGIN_FORM);
    }
    return null;
  }

  bool isUserLoggedIn() {
    return controller.isLogggIn.value;
  }
}
