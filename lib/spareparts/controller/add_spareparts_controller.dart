import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddSparepartsController extends GetxController {
  final modelParts = TextEditingController();
  final jenisParts = TextEditingController();
  final hargaParts = TextEditingController();
  final maklumatParts = TextEditingController();
  final kuantitiParts = TextEditingController();

  var selectedSupplier = 'MG'.obs;
  var selectedQuality = 'OEM'.obs;

  var currentSteps = 0.obs;

  final focusJenisSparepart = new FocusNode();
  final focusModelSmartphone = new FocusNode();
  final focusHargaParts = new FocusNode();
  final focusMaklumatParts = new FocusNode();
  final focusKuantitiParts = new FocusNode();

  String generateID() {
    var dateID = DateTime.now().millisecondsSinceEpoch.toString();
    return dateID;
  }

  void nextStepper() {
    // final lastStep =
    //     currentSteps.value == AddSparepartStepper().getStepper().length - 1;
    Haptic.feedbackClick();
    if (currentSteps.value == 0) {
      currentSteps += 1;
      Get.focusScope.requestFocus(focusModelSmartphone);
    } else if (currentSteps.value == 1) {
      currentSteps += 1;
      focusJenisSparepart.requestFocus();
    } else if (currentSteps.value == 2) {
      focusJenisSparepart.unfocus();
      currentSteps += 1;
    } else if (currentSteps.value == 3) {
      focusHargaParts.requestFocus();
      currentSteps += 1;
    } else if (currentSteps.value == 4) {
      focusMaklumatParts.requestFocus();
      currentSteps += 1;
    } else if (currentSteps.value == 5) {
      focusKuantitiParts.requestFocus();
      currentSteps += 1;
    } else if (currentSteps.value == 6) {
      focusKuantitiParts.unfocus();
      currentSteps += 1;
    } else if (currentSteps.value == 7) {
      print('send to backend');
    }
  }

  void backStepper() {
    Haptic.feedbackError();
    Get.focusScope.unfocus();
    currentSteps -= 1;
  }
}
