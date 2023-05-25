import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../spareparts/model/sparepart_model.dart';

class SparepartController extends GetxController {
  List<Spareparts> spareparts = [];
  var totalPartsPrice = 00.00.obs;
  var totalSpareparts = 0.obs;

  var isSearch = false.obs;

  Future? getPartList;

  @override
  void onInit() {
    getPartList = getSparepartsList();
    super.onInit();
  }

  void goToDetails(Map<String, dynamic> arguments, String id) {
    Haptic.feedbackClick();

    Get.toNamed(
      MyRoutes.sparepartsDetails,
      arguments: arguments,
      parameters: {
        'id': id,
      },
    );
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
        const AlertDialog(
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
    if (onAppBar == true) {
      ShowSnackbar.success('Segar Semula', 'Segar semula selesai', false);
    }
  }

  Future<void> getSparepartsList() async {
    bool internet = true;
    var connect = await ConnectivityWrapper.instance.isConnected;

    if (GetPlatform.isWeb) {
      internet = true;
    } else {
      internet = connect;
    }

    if (internet == true) {
      await FirebaseDatabase.instance
          .ref()
          .child("Spareparts")
          .get()
          .then((snapshot) async {
        spareparts.clear();
        Map<dynamic, dynamic>? values = snapshot.value as Map<dynamic, dynamic>;
        try {} catch (e) {
          debugPrint(e.toString());
        }
        totalPartsPrice.value = 00.00;
        values.forEach((key, value) {
          spareparts.add(Spareparts.fromRealtimeDatabase(value));
          totalSpareparts.value = spareparts.length;
          totalPartsPrice.value += double.parse(value['Harga']);
        });

        spareparts.sort((a, b) => b.tarikh.compareTo(a.tarikh));
      });
      if (!GetPlatform.isWeb) {
        // spareparts.forEach((element) async {
        //   Spareparts parts = Spareparts(
        //       id: element.id,
        //       model: element.model,
        //       jenisSpareparts: element.jenisSpareparts,
        //       supplier: element.supplier,
        //       kualiti: element.kualiti,
        //       maklumatSpareparts: element.maklumatSpareparts,
        //       tarikh: element.tarikh,
        //       harga: element.harga,
        //       partsID: element.id);
        //   // await DatabaseHelper.instance.deleteSparepartsCache();
        //   // await DatabaseHelper.instance.addSparepartsCache(parts);
        // });
      }
    } else {
      debugPrint('offline mode');
      spareparts = [];
      totalPartsPrice.value = 00.00;
      // var cache = await DatabaseHelper.instance.getSparepartsCache();
      // spareparts = cache;
      totalSpareparts.value = spareparts.length;
      for (var element in spareparts) {
        totalPartsPrice.value += double.parse(element.harga);
      }
      spareparts.sort((a, b) => b.tarikh.compareTo(a.tarikh));
    }
  }
}
