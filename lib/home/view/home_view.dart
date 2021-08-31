import 'package:admin_panel/home/controller/home_controller.dart';
import 'package:admin_panel/home/page/customer_page.dart';
import 'package:admin_panel/home/page/dashboard_page.dart';
import 'package:admin_panel/home/page/mysid_page.dart';
import 'package:admin_panel/home/page/pos_page.dart';
import 'package:admin_panel/home/page/sparepart_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  final _homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: _homeController.currentIndex.value,
          children: [
            DashboardPage(),
            CustomerPage(),
            MySidPage(),
            SparepartPage(),
            SettingPage(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _homeController.currentIndex.value,
          onTap: (index) => _homeController.currentIndex.value = index,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Utama',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Pelanggan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.date_range),
              label: 'MySID',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Spareparts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: 'Lain',
            ),
          ],
        ),
      ),
    );
  }
}
