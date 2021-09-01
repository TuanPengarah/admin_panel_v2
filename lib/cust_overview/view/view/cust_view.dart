import 'package:admin_panel/cust_overview/controller/overview_controller.dart';
import 'package:admin_panel/cust_overview/page/history_cust.dart';
import 'package:admin_panel/cust_overview/page/info_cust.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerView extends StatelessWidget {
  final _overviewController = Get.put(OverviewController());

  final _screen = [
    CustomerInfoPage(),
    RepairHistoryPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _overviewController.exitSaveuser(),
      child: Scaffold(
        bottomNavigationBar: Obx(() => BottomNavigationBar(
              onTap: (index) => _overviewController.currentIndex.value = index,
              currentIndex: _overviewController.currentIndex.value,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Maklumat'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.history), label: 'Sejarah Baiki'),
              ],
            )),
        body: Obx(
          () => _screen[_overviewController.currentIndex.value],
        ),
      ),
    );
  }
}
