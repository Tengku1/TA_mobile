import 'package:mobile_ta/pages/Search_Availability_Page/main_page.dart';
import 'package:mobile_ta/pages/auth/login_page.dart';
import 'package:mobile_ta/pages/home/home_page.dart';
import 'package:mobile_ta/pages/auth/register_page.dart';
import 'package:mobile_ta/pages/List_Hotel_Order/main_page.dart';
import 'package:get/get.dart';
import 'package:mobile_ta/pages/user/main_page.dart';
import '../routes/route_paths.dart';

class AppRoutes {
  static final getRoutes = [
    GetPage(name: RoutePaths.INITIAL, page: () => HomePage(0)),
    GetPage(name: RoutePaths.REGISTER_FORM, page: () => RegisterPage()),
    GetPage(name: RoutePaths.LOGIN_FORM, page: () => LoginPage()),
    GetPage(
        name: RoutePaths.HOTEL_AVAILABILITY_FORM,
        page: () => SearchAvailabilityPage()),
    GetPage(name: RoutePaths.MY_ORDER, page: () => ListHotelOrder()),
    GetPage(name: RoutePaths.PROFILE, page: () => ProfilePage()),
  ];
}
