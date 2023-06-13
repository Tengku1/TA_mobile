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
    print(authController.usersData);

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
                Text(
                  'Name: ${authController.usersData['name']}',
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  'Surname: ${authController.usersData['surname']}',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 16),
                Text(
                  'Email: ${authController.usersData['email']}',
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  'Telephone: ${authController.usersData['telephone']}',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    // Tambahkan logika update profil di sini
                    Get.snackbar('Update Profil', 'Profil telah diperbarui');
                  },
                  child: const Text('Update Profil'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    authController.usersData.clear();
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
