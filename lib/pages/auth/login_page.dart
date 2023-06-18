import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ta/pages/auth/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final controller = Get.put(AuthController());
  final formKey = GlobalKey<FormState>();
  final errorMessage = "".obs;

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.usersData.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offNamed('/');
      });
    }

    return GetBuilder<AuthController>(
        builder: (controller) => Scaffold(
              body: Center(
                  child: SingleChildScrollView(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Login Form",
                                      style: TextStyle(fontSize: 30)),
                                  const SizedBox(height: 40),
                                  TextFormField(
                                    controller: controller.emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                        labelText: 'Email'),
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
                                  TextFormField(
                                    obscureText: true,
                                    controller: controller.pwdController,
                                    decoration: const InputDecoration(
                                      labelText: 'Password',
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        errorMessage.value =
                                            'Kolom Tidak Boleh Kosong';
                                        return 'Kolom Tidak Boleh Kosong';
                                      }
                                      if (value.length < 8) {
                                        errorMessage.value =
                                            'Password minimal 8 Karakter';
                                        return 'Password minimal 8 Karakter';
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
                                              if (formKey.currentState!
                                                  .validate()) {
                                                await controller.login();
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
                                  const SizedBox(height: 20),
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed("/register");
                                    },
                                    child: const Text(
                                      'Belum Punya Akun ? Register Sekarang !',
                                      style: TextStyle(
                                          fontSize: 12,
                                          decoration: TextDecoration.underline,
                                          color: Colors.blue),
                                    ),
                                  ),
                                ]),
                          )))),
            ));
  }
}
