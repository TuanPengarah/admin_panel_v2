import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowSnackbar {
  static void success(String title, String message) {
    Get.showSnackbar(
      GetBar(
        title: '$title',
        message: '$message',
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        snackStyle: SnackStyle.GROUNDED,
      ),
    );
  }

  static void error(String title, String message) {
    Get.showSnackbar(
      GetBar(
        title: '$title',
        message: '$message',
        backgroundColor: Colors.amber[900],
        duration: Duration(seconds: 5),
        snackPosition: SnackPosition.TOP,
        snackStyle: SnackStyle.GROUNDED,
      ),
    );
  }
}
