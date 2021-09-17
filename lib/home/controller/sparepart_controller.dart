import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:admin_panel/cust_overview/model/popupmenu_overview.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  void popupMenuSeleceted(
      IconMenuOverview value, String id, String model, String jenis) async {
    switch (value) {
      case PopupMenuOverview.edit:
        print('edit');
        break;
      case PopupMenuOverview.delete:
        await deleteSpareparts(id, model, jenis);
        break;
    }
  }

  Future<void> deleteSpareparts(String id, String model, String jenis) async {
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
    await FirebaseDatabase.instance
        .reference()
        .child('Spareparts')
        .child(id)
        .remove()
        .then((value) async {
      await refreshDialog(false);
      Haptic.feedbackSuccess();
      Get.back();
      Get.back();
      Get.back();

      ShowSnackbar.notify('Padam Spareparts',
          'Spareparts $model ($jenis) telah dipadam dari server!');
    });
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
    ShowSnackbar.success('Segar Semula', 'Segar semula selesai', false);
  }

  void deletedList(int i) {
    spareparts.removeAt(i);
    update();
  }

  Future<void> getSparepartsList() async {
    print('running');
    await FirebaseDatabase.instance
        .reference()
        .child("Spareparts")
        .orderByChild('Model')
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
    });

    // FirebaseDatabase.instance
    //     .reference()
    //     .child('Spareparts')
    //     .orderByChild('Model')
    //     .equalTo('iPhone')
    //     .onChildAdded
    //     .listen((_onEntryAdded));

    // FirebaseDatabase.instance
    //     .reference()
    //     .child('Spareparts')
    //     .orderByChild('Model')
    //     .equalTo('iPhone')
    //     .onChildChanged
    //     .listen((_onEntryChanged));
  }

  // _onEntryAdded(Event event) {
  //   spareparts.add(Spareparts.fromSnapshot(event.snapshot));
  // }

  // _onEntryChanged(Event event) {
  //   var oldEntry = spareparts.singleWhere((entry) {
  //     return entry.key == event.snapshot.key;
  //   });

  //   spareparts[spareparts.indexOf(oldEntry)] =
  //       Spareparts.fromSnapshot(event.snapshot);
  // }
}
