import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MysidController extends GetxController {
  final repairLog = TextEditingController();
  final _data = Get.arguments;
  var percentage = 0.0.obs;
  var progressPercent = 0.0.obs;
  @override
  void onInit() {
    checkPercent();
    super.onInit();
  }

  void checkPercent() {
    progressPercent.value = _data['Percent'];
    var multiply = _data['Percent'] * 100;
    percentage.value = multiply;
    Future.delayed(Duration(milliseconds: 500), () {
      Haptic.feedbackSuccess();
    });
  }
}
