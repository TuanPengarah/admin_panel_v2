import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;

  void showBottomJosheet() async {
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
                Get.toNamed('/jobsheet');
              },
            ),
            ListTile(
                leading: Icon(Icons.assignment_ind),
                title: Text('Buat Jobsheet dengan pelanggan sedia ada'),
                onTap: () {}),
          ],
        ),
      ),
    );
  }
}
