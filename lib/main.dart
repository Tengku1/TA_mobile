import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';

import 'routes/route_paths.dart';
import 'routes/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    OverlaySupport.global(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sistem Booking Hotel',
        theme: ThemeData(
          brightness: Brightness.light,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'NeueHaasGrotesk',
        ),
        builder: EasyLoading.init(),
        locale: Get.deviceLocale,
        defaultTransition: Transition.native,
        initialRoute: RoutePaths.INITIAL,
        getPages: AppRoutes.getRoutes,
      ),
    ),
  );
}
