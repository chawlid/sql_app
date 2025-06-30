import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:notification_crypto_coins/helper/helpers.dart';
import 'package:notification_crypto_coins/main.dart';
import 'package:notification_crypto_coins/send.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(20),
        child: FutureBuilder<bool>(
          future: insertToken(tokenGlobale),

          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              // Token inserted successfully, navigate to Send page
              if (snapshot.data == false) {
                return Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline_outlined,
                        size: 50,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'An error occurred. Please try again later.',
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Retry inserting the token
                          setState(() {});
                        },
                        child: const Text('Refresh'),
                      ),
                    ],
                  ),
                );
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // Token already exists, navigate to Send page
                  Get.offAll(
                    () => const Send(),
                    duration: const Duration(milliseconds: 500),
                  );
                });

                return const Center(child: CircularProgressIndicator());
              }
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Loading...',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const CircularProgressIndicator(),
              ],
            );
          },
        ),
      ),
    );
  }
}
