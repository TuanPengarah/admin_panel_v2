import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;
  var totalMysid = 0.obs;

  void navTap(int index) {
    currentIndex.value = index;
  }

  void showBottomJosheet() async {
    Haptic.feedbackClick();
    await Get.bottomSheet(
      Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Buat Jobsheet baru'),
              onTap: () {
                Get.back();
                Get.toNamed(MyRoutes.jobsheet,
                    arguments: [false, '', '', '', '']);
              },
            ),
            ListTile(
                leading: Icon(Icons.assignment_ind),
                title: Text('Buat Jobsheet dengan pelanggan sedia ada'),
                onTap: () {
                  Get.back();
                  currentIndex.value = 1;
                  ShowSnackbar.notify('Pilih Pelanggan',
                      'Sila pilih pelanggan dan tekan tambah Jobsheet');
                }),
          ],
        ),
      ),
      enterBottomSheetDuration: Duration(milliseconds: 150),
      exitBottomSheetDuration: Duration(milliseconds: 150),
    );
  }
}
