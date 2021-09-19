import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SparepartController extends GetxController {
  List spareparts = [];
  var totalPartsPrice = 00.00.obs;
  var totalSpareparts = 0.obs;

  Future getPartList;

  @override
  void onInit() {
    getPartList = getSparepartsList();
    super.onInit();
  }

  String convertEpoch(String unix) {
    var convertDate = DateTime.fromMillisecondsSinceEpoch(int.parse(unix));
    var dateFormat = DateFormat('dd-MM-yyyy | hh:mm a');
    return dateFormat.format(convertDate);
  }

  Future<void> refreshDialog(bool onAppBar) async {
    Haptic.feedbackClick();
    if (onAppBar == true) {
      Get.dialog(
        AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
    }

    await getSparepartsList();

    Haptic.feedbackSuccess();
    if (onAppBar == true) {
      Get.back();
    }
    update();
    if (onAppBar == true)
      ShowSnackbar.success('Segar Semula', 'Segar semula selesai', false);
  }

  Future<void> getSparepartsList() async {
    print('running');
    await FirebaseDatabase.instance
        .reference()
        .child("Spareparts")
        .once()
        .then((snapshot) {
      spareparts.clear();
      totalPartsPrice.value = 00.00;
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        spareparts.add(values);

        totalSpareparts.value = spareparts.length;
        totalPartsPrice.value += int.parse(values['Harga']);
      });
      spareparts..sort((a, b) => b['Tarikh'].compareTo(a['Tarikh']));
    });
  }
}
