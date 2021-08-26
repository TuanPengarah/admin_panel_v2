import 'dart:math';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class JobsheetController extends GetxController {
  final namaCust = TextEditingController();
  final noPhone = TextEditingController();
  final email = TextEditingController();
  final modelPhone = TextEditingController();
  final passPhone = TextEditingController();
  final kerosakkan = TextEditingController();
  final harga = TextEditingController();
  final remarks = TextEditingController();

  final FlutterContactPicker _contactPicker = new FlutterContactPicker();

  var errNama = false.obs;
  var errNoPhone = false.obs;
  var errModel = false.obs;
  var errKerosakkan = false.obs;
  var errPrice = false.obs;

  var currentSteps = 0.obs;

  var mySID = ''.obs;

  @override
  void onInit() {
    generateMySID();
    super.onInit();
  }

  Future<bool> exitJobSheet() async {
    bool result = false;
    if (namaCust.text.isNotEmpty) {
      await Get.dialog(
        AlertDialog(
          title: Text('Anda pasti untuk keluar?'),
          content: Text(
              'Segala maklumat yang telah anda masukkan di Jobsheet ini akan di padam!'),
          actions: [
            TextButton(
              onPressed: () {
                result = false;
                Get.back();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                result = true;
                Get.back();
              },
              child: Text(
                'Keluar',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      result = true;
    }
    return result;
  }

  void generateMySID() {
    var random = Random();
    String converter = random.nextInt(999999).toString().padLeft(6, '0');
    mySID.value = converter;
  }

  void nextStep() {
    Haptic.feedbackClick();
    if (currentSteps.value == 0) {
      if (namaCust.text.isEmpty) {
        Haptic.feedbackError();
        errNama.value = true;
      } else {
        currentSteps.value++;
        errNama.value = false;
      }
    } else if (currentSteps.value == 1) {
      if (noPhone.text.isEmpty) {
        Haptic.feedbackError();
        errNoPhone.value = true;
      } else {
        currentSteps.value++;
        errNoPhone.value = false;
      }
    } else if (currentSteps.value == 2) {
      currentSteps.value++;
    } else if (currentSteps.value == 3) {
      if (modelPhone.text.isEmpty) {
        errModel.value = true;
        Haptic.feedbackError();
      } else {
        currentSteps.value++;
        errModel.value = false;
      }
    } else if (currentSteps.value == 4) {
      currentSteps.value++;
    } else if (currentSteps.value == 5) {
      if (kerosakkan.text.isEmpty) {
        errKerosakkan.value = true;
        Haptic.feedbackError();
      } else {
        currentSteps.value++;
        errKerosakkan.value = false;
      }
    } else if (currentSteps.value == 6) {
      if (harga.text.isEmpty) {
        Haptic.feedbackError();
        errPrice.value = true;
      } else {
        currentSteps.value++;
        errPrice.value = false;
      }
    } else if (currentSteps.value == 7) {
      Get.back();
    }
  }

  void previousStep() {
    Get.focusScope.unfocus();
    if (currentSteps.value > 0) {
      currentSteps.value = currentSteps.value - 1;
    } else {
      currentSteps.value = 0;
    }
  }

  void stepTap(int index) {
    Get.focusScope.unfocus();
  }

  void selectContact() async {
    if (kIsWeb) {
      Get.dialog(
        AlertDialog(
          title: Text('Opps kesalahan telah berlaku'),
          content: Text(
              'Fungsi ini hanya boleh digunakan pada Android dan iOS sahaja!'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Okayy'),
            ),
          ],
        ),
      );
    } else {
      final contact = await _contactPicker.selectContact();
      if (contact != null) {
        namaCust.text = contact.fullName;
        noPhone.text = contact.phoneNumbers.first;
      }
    }
  }
}
