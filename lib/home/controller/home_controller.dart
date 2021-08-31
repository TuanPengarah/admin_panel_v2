import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/home/page/customer_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;

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
                  Get.to(() => CustomerPage());
                }),
          ],
        ),
      ),
      enterBottomSheetDuration: Duration(milliseconds: 150),
      exitBottomSheetDuration: Duration(milliseconds: 150),
    );
  }
}
