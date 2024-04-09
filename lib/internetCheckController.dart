import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InternetCheck extends GetxService {
  // Future<bool> internetConnection() async {
  //   try {
  //     var connectivityResult = await Connectivity().checkConnectivity();
  //     return connectivityResult != ConnectivityResult.none;
  //   } on SocketException catch (_) {
  //     // Handle SocketException (e.g., no internet connection)
  //     return false;
  //   } catch (e) {
  //     // Handle other exceptions
  //     print("Error checking internet connection: $e");
  //     return false;
  //   }
  // }

  void noInternetSnackbar() {
    Get.rawSnackbar(
      padding: const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 15),
      icon: const Icon(
        Icons.wifi_off,
        size: 30,
      ),
      borderRadius: 20,
      backgroundColor: Colors.teal.shade200,
      titleText: const Text(
        "No Internet",
        style: TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      messageText: const Text(
        "Please connect to any network.",
        style: TextStyle(
          color: Colors.black,
          fontSize: 13,
        ),
      ),
      isDismissible: true,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(15),
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  //  success
  void newDonorAddSnackbar() {
    Get.rawSnackbar(
      padding: const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 15),
      icon: const Icon(
        Icons.done,
        size: 30,
      ),
      borderRadius: 20,
      backgroundColor: Colors.teal.shade200,
      titleText: const Text(
        "Success...",
        style: TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      messageText: const Text(
        "New Donor Added Successfully...",
        style: TextStyle(
          color: Colors.black,
          fontSize: 13,
        ),
      ),
      isDismissible: true,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(15),
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }
}
