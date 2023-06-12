import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ta/pages/auth/auth_controller.dart';

class RegisterPage extends StatelessWidget {
  final controller = Get.put(AuthController());
  final formKey = GlobalKey<FormState>();
  final errorMessage = "".obs;

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                            const Text("Register Form",
                                style: TextStyle(fontSize: 30)),
                            const SizedBox(height: 40),
                            TextFormField(
                              controller: controller.usernameController,
                              keyboardType: TextInputType.text,
                              decoration:
                                  const InputDecoration(labelText: 'Username'),
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
                              controller: controller.emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration:
                                  const InputDecoration(labelText: 'Email'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  errorMessage.value =
                                      'Kolom Tidak Boleh Kosong';
                                  return 'Kolom Tidak Boleh Kosong';
                                }
                                if (!value.isEmail) {
                                  errorMessage.value =
                                      'Masukkan Format Email Yang Benar !';
                                  return 'Masukkan Format Email Yang Benar !';
                                }
                                errorMessage.value = "";
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: controller.phoneController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Phone Number'),
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
                              controller: controller.pwdController,
                              keyboardType: TextInputType.text,
                              decoration:
                                  const InputDecoration(labelText: 'Password'),
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
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (formKey.currentState!.validate()) {
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
                                Get.toNamed("/");
                              },
                              child: const Text(
                                'Sudah Punya Akun ? Login Sekarang !',
                                style: TextStyle(
                                    fontSize: 12,
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue),
                              ),
                            ),
                          ]),
                    )),
              )),
            ));
  }
}
