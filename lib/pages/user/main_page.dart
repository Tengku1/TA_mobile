import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ta/main_controller.dart';
import 'package:mobile_ta/pages/auth/auth_controller.dart';

class ProfilePage extends StatelessWidget {
  final authController = Get.put(AuthController());
  final controller = Get.put(MainController());

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (authController.usersData.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offNamed('/login');
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Profil'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                      labelText: "${authController.usersData['name']}",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                      labelText: "${authController.usersData['surname']}",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                      labelText: "${authController.usersData['email']}",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                      labelText: "${authController.usersData['telephone']}",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    authController.usersData.clear();
                    authController.isLogggIn.value = false;
                    Get.snackbar('Logout', 'Anda telah logout');
                    Get.offNamed("/");
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Obx(() => BottomNavigationBar(
              currentIndex: controller.selectedIndex.value,
              selectedItemColor: Colors.blue,
              onTap: (index) => controller.onTabBtn(index),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.local_hotel_rounded),
                  label: 'Hotel Order',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            )));
  }
}
