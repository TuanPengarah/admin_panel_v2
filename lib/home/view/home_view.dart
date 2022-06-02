import 'package:admin_panel/home/controller/home_controller.dart';
import 'package:admin_panel/home/page/customer_page.dart';
import 'package:admin_panel/home/page/dashboard_page.dart';
import 'package:admin_panel/home/page/mysid_page.dart';
import 'package:admin_panel/home/page/others_page.dart';
import 'package:admin_panel/home/page/sparepart_page.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: _homeController.currentIndex.value,
          children: [
            DashboardPage(),
            CustomerPage(false),
            MySidPage(),
            SparepartPage(),
            SettingPage(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() {
        return NavigationBar(
          selectedIndex: _homeController.currentIndex.value,
          onDestinationSelected: (index) => _homeController.navTap(index),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          animationDuration: Duration(milliseconds: 500),
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: 'Utama',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outlined),
              selectedIcon: Icon(Icons.person),
              label: 'Pelanggan',
            ),
            NavigationDestination(
              icon: Obx(
                () => _homeController.totalMysid.value == 0
                    ? Icon(Icons.date_range_outlined)
                    : Badge(
                        badgeContent: Text(
                            '${_homeController.totalMysid.value}',
                            style: TextStyle(color: Colors.white)),
                        child: Icon(Icons.date_range_outlined),
                        animationType: BadgeAnimationType.scale,
                        animationDuration: Duration(milliseconds: 200),
                      ),
              ),
              selectedIcon: Obx(
                () => _homeController.totalMysid.value == 0
                    ? Icon(Icons.date_range)
                    : Badge(
                        badgeContent: Text(
                          '${_homeController.totalMysid.value}',
                          style: TextStyle(color: Colors.white),
                        ),
                        child: Icon(Icons.date_range),
                        animationType: BadgeAnimationType.scale,
                        animationDuration: Duration(milliseconds: 200),
                      ),
              ),
              label: 'MySID',
            ),
            NavigationDestination(
              icon: Icon(Icons.category_outlined),
              selectedIcon: Icon(Icons.category),
              label: 'Parts',
            ),
            NavigationDestination(
              icon: Icon(Icons.more_horiz_outlined),
              selectedIcon: Icon(Icons.more_horiz),
              label: 'Lain',
            ),
          ],
        );
      }),
    );
  }
}
