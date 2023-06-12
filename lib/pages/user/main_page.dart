import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ta/pages/auth/auth_controller.dart';

class ProfilePage extends StatelessWidget {
  final authController = Get.put(AuthController());

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
      body: Padding(
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
                // Tambahkan logika logout di sini
                Get.snackbar('Logout', 'Anda telah logout');
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
