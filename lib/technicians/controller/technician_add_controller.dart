import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TechnicianAddController extends GetxController {
  var currentSteps = 0.obs;

  final namaStaff = TextEditingController();
  final emailStaff = TextEditingController();

  final staffFocus = new FocusNode();
  final emailFocus = new FocusNode();

  var errStaff = false.obs;
  var errEmail = false.obs;

  var selectedJawatan = 'Technician'.obs;
  var selectedCawangan = 'Kajang'.obs;

  void nextStepper() {
    Haptic.feedbackClick();
    if (currentSteps.value == 0) {
      if (namaStaff.text.isEmpty) {
        Haptic.feedbackError();
        errStaff.value = true;
      } else {
        currentSteps.value++;
        errStaff.value = false;
        staffFocus.unfocus();
      }
    } else if (currentSteps.value == 1) {
      currentSteps.value++;
    } else if (currentSteps.value == 2) {
      currentSteps.value++;
      emailFocus.requestFocus();
    } else if (currentSteps.value == 3) {
      if (emailStaff.text.isEmpty) {
        errEmail.value = true;
        Haptic.feedbackError();
      } else {
        currentSteps.value++;
        emailFocus.unfocus();
      }
    } else if (currentSteps.value == 4) {
      currentSteps.value++;
    } else if (currentSteps.value == 6) {
      ///TODO: add to backend!
    }
  }

  void backStepper() {
    Haptic.feedbackError();
    Get.focusScope.unfocus();
    currentSteps.value -= 1;
  }

  void choosePictureDialog() {
    Haptic.feedbackClick();
    Get.dialog(
      AlertDialog(
        content: Column(),
      ),
    );
  }
}
