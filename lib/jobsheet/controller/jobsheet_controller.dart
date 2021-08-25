import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobsheetController extends GetxController {
  final namaCust = TextEditingController();
  final noPhone = TextEditingController();
  final email = TextEditingController();
  final modelPhone = TextEditingController();
  final passPhone = TextEditingController();
  final kerosakkan = TextEditingController();
  final harga = TextEditingController();
  final remarks = TextEditingController();

  var currentSteps = 0.obs;

  void nextStep() {
    Haptic.feedbackClick();
    if (currentSteps.value == 0) {
      currentSteps.value++;
    } else if (currentSteps.value == 1) {
      currentSteps.value++;
    } else if (currentSteps.value == 2) {
      currentSteps.value++;
    } else if (currentSteps.value == 3) {
      currentSteps.value++;
    } else if (currentSteps.value == 4) {
      currentSteps.value++;
    } else if (currentSteps.value == 5) {
      currentSteps.value++;
    } else if (currentSteps.value == 6) {
      currentSteps.value++;
    } else if (currentSteps.value == 7) {
      Get.back();
    }
  }

  void previousStep() {
    if (currentSteps.value > 0) {
      currentSteps.value = currentSteps.value - 1;
    } else {
      Get.back();
    }
  }
}
