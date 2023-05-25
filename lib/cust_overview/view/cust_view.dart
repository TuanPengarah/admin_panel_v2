import 'package:admin_panel/cust_overview/controller/overview_controller.dart';
import 'package:admin_panel/cust_overview/page/history_cust.dart';
import 'package:admin_panel/cust_overview/page/info_cust.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerView extends StatelessWidget {
  final _overviewController = Get.put(OverviewController());
  final _data = Get.arguments;
  final _screen = [
    CustomerInfoPage(),
    const RepairHistoryPage(),
  ];

  CustomerView({super.key});
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Hero(
        tag: _data['UID'],
        child: Scaffold(
          bottomNavigationBar: Obx(() => NavigationBar(
                onDestinationSelected: (index) =>
                    _overviewController.currentIndex.value = index,
                animationDuration: const Duration(milliseconds: 500),
                selectedIndex: _overviewController.currentIndex.value,
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.person_outline),
                    selectedIcon: Icon(Icons.person),
                    label: 'Maklumat',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.history_outlined),
                    selectedIcon: Icon(Icons.history),
                    label: 'Sejarah Baiki',
                  ),
                ],
              )),
          body: Obx(
            () => _screen[_overviewController.currentIndex.value],
          ),
        ),
      ),
    );
  }
}
