import 'dart:math';

import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:admin_panel/home/controller/sparepart_controller.dart';
import 'package:admin_panel/spareparts/model/sparepart_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddSparepartsController extends GetxController {
  final _sparepartsController = Get.find<SparepartController>();

  final modelParts = TextEditingController();
  final jenisParts = TextEditingController();
  final hargaParts = TextEditingController();
  final maklumatParts = TextEditingController();
  final kuantitiParts = TextEditingController();

  var selectedSupplier = 'MG'.obs;
  var selectedQuality = 'OEM'.obs;

  var currentSteps = 0.obs;
  var timeStamp = ''.obs;
  var partsID = ''.obs;
  var status = ''.obs;

  final focusJenisSparepart = new FocusNode();
  final focusModelSmartphone = new FocusNode();
  final focusHargaParts = new FocusNode();
  final focusMaklumatParts = new FocusNode();
  final focusKuantitiParts = new FocusNode();

  var errModelParts = false.obs;
  var errJenisParts = false.obs;
  var errHargaParts = false.obs;
  var errMaklumatParts = false.obs;
  var errKuantitiParts = false.obs;

  @override
  void onInit() {
    generateTimestamp();
    generatePartsID();
    super.onInit();
  }

  void generateTimestamp() {
    var dateID = DateTime.now().millisecondsSinceEpoch.toString();
    timeStamp.value = dateID;
  }

  void generatePartsID() {
    var random = Random();
    String converter = random.nextInt(999999).toString().padLeft(6, '0');
    partsID.value = converter;
  }

  void nextStepper() {
    // final lastStep =
    //     currentSteps.value == AddSparepartStepper().getStepper().length - 1;
    Haptic.feedbackClick();
    if (currentSteps.value == 0) {
      currentSteps += 1;
      Get.focusScope.requestFocus(focusModelSmartphone);
    } else if (currentSteps.value == 1) {
      if (modelParts.text.isEmpty) {
        errModelParts.value = true;
      } else {
        currentSteps += 1;
        errModelParts.value = false;
        focusJenisSparepart.requestFocus();
      }
    } else if (currentSteps.value == 2) {
      if (jenisParts.text.isEmpty) {
        errJenisParts.value = true;
      } else {
        currentSteps += 1;
        errJenisParts.value = false;
        focusJenisSparepart.unfocus();
      }
    } else if (currentSteps.value == 3) {
      focusHargaParts.requestFocus();
      currentSteps += 1;
    } else if (currentSteps.value == 4) {
      if (hargaParts.text.isEmpty) {
        errHargaParts.value = true;
      } else {
        currentSteps += 1;
        errHargaParts.value = false;
        focusMaklumatParts.requestFocus();
      }
    } else if (currentSteps.value == 5) {
      if (maklumatParts.text.isEmpty) {
        errMaklumatParts.value = true;
      } else {
        currentSteps += 1;
        errMaklumatParts.value = false;
        focusKuantitiParts.requestFocus();
      }
    } else if (currentSteps.value == 6) {
      if (kuantitiParts.text.isEmpty) {
        errKuantitiParts.value = true;
      } else {
        currentSteps += 1;
        errKuantitiParts.value = false;
        focusKuantitiParts.unfocus();
      }
    } else if (currentSteps.value == 7) {
      addToRTDB();
    }
  }

  void backStepper() {
    Haptic.feedbackError();
    Get.focusScope.unfocus();
    currentSteps -= 1;
  }

  Future<void> addToRTDB() async {
    status.value = 'Menyediakan maklumat spareparts anda...';

    Get.dialog(AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 30),
          Obx(() => Text(
                status.value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              )),
        ],
      ),
    ));

    try {
      for (int i = 0; i < int.parse(kuantitiParts.text); i++) {
        generatePartsID();
        Spareparts spareparts = new Spareparts(
            partsID.value,
            modelParts.text,
            jenisParts.text,
            selectedSupplier.value,
            selectedQuality.value,
            maklumatParts.text,
            timeStamp.value,
            hargaParts.text,
            partsID.value);
        await Future.delayed(Duration(milliseconds: 100));
        status.value =
            'Memasukkan maklumat spareparts anda ke pangkalan data...';
        await FirebaseDatabase.instance
            .reference()
            .child('Spareparts')
            .child(partsID.value)
            .set(spareparts.toJson());
      }

      status.value = 'Selesai!';
      Haptic.feedbackSuccess();
      await _sparepartsController.refreshDialog(false);
      await Future.delayed(Duration(seconds: 1));
      Get.back();
      Get.back();
      Get.back();
      ShowSnackbar.success('Tambah spareparts berjaya!',
          'Maklumat spareparts anda telah ditambah ke server!', false);
    } on Exception catch (e) {
      status.value = 'Opps! Kesalahan talah berlaku: $e';
      Haptic.feedbackError();
      await Future.delayed(Duration(seconds: 2));
      Get.back();
      ShowSnackbar.error('Gagal untuk menambah spareparts',
          'Kesalahan telah berlaku: $e', false);
    }
  }
}
