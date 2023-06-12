import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({
    Key? key,
    required this.message,
    required this.headMessage,
    this.buttonText = 'Go Back',
    this.title = '',
    this.onTap,
  }) : super(key: key);

  final String message;
  final String headMessage;
  final String buttonText;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/icons/red_warning.png',
                  height: 200,
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  headMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333)),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333)),
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Color(0xFFebebeb), width: 2))),
                child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: onTap ?? Get.back,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFf9a630),
                        ),
                        child: Text(
                          buttonText,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
