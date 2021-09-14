import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowSnackbar {
  static void success(String title, String message, bool isTop) {
    Get.snackbar(
      title,
      message,
      colorText: Colors.white,
      backgroundColor: Colors.lightGreen.shade700,
      duration: Duration(seconds: 3),
      animationDuration: Duration(milliseconds: 350),
      snackPosition: isTop == true ? SnackPosition.TOP : SnackPosition.BOTTOM,
      snackStyle: SnackStyle.FLOATING,
      icon: Icon(Icons.done, color: Colors.white),
      margin: EdgeInsets.all(10),
    );
  }

  static void error(String title, String message, bool isTop) {
    Get.snackbar(
      title,
      message,
      colorText: Colors.white,
      backgroundColor: Colors.amber[900],
      duration: Duration(seconds: 5),
      animationDuration: Duration(milliseconds: 350),
      snackPosition: isTop == true ? SnackPosition.TOP : SnackPosition.BOTTOM,
      snackStyle: SnackStyle.FLOATING,
      icon: Icon(Icons.close, color: Colors.white),
      margin: EdgeInsets.all(10),
    );
  }

  static void notify(String title, String message) {
    Get.snackbar(
      title,
      message,
      colorText: Colors.white,
      backgroundColor: Colors.grey[900],
      duration: Duration(seconds: 5),
      animationDuration: Duration(milliseconds: 350),
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
      icon: Icon(Icons.notifications, color: Colors.white),
      margin: EdgeInsets.all(10),
    );
  }
}
