import 'package:admin_panel/config/get_route_export.dart';
import 'package:admin_panel/home/controller/home_controller.dart';
import 'package:admin_panel/home/page/customer_page.dart';
import 'package:admin_panel/home/page/dashboard_page_v2.dart';
import 'package:admin_panel/home/page/mysid_page.dart';
import 'package:admin_panel/home/page/sparepart_page.dart';
import 'package:badges/badges.dart' as badge;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

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
            DashboardPage2(),
            CustomerPage(false),
            MySidPage(),
            SparepartPage(),
            PriceListView(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            labelTextStyle:
                MaterialStateProperty.all<TextStyle>(const TextStyle(
          fontSize: 12,
        ))),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('MyrepairID')
                .orderBy('isPayment', descending: false)
                .where('isPayment', isNotEqualTo: true)
                .orderBy('timeStamp', descending: false)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return Obx(() {
                return NavigationBar(
                  selectedIndex: _homeController.currentIndex.value,
                  onDestinationSelected: (index) =>
                      _homeController.navTap(index),
                  labelBehavior:
                      NavigationDestinationLabelBehavior.onlyShowSelected,
                  animationDuration: const Duration(milliseconds: 500),
                  destinations: [
                    const NavigationDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(Icons.dashboard),
                      label: 'Utama',
                    ),
                    const NavigationDestination(
                      icon: Icon(Icons.person_outlined),
                      selectedIcon: Icon(Icons.person),
                      label: 'Pelanggan',
                    ),
                    NavigationDestination(
                      icon: snapshot.data == null || snapshot.data!.docs.isEmpty
                          ? const Icon(Icons.date_range_outlined)
                          : badge.Badge(
                              badgeContent: Text(
                                  '${snapshot.data!.docs.length}',
                                  style: const TextStyle(color: Colors.white)),
                              badgeAnimation:
                                  const badge.BadgeAnimation.scale(),
                              child: const Icon(Icons.date_range_outlined),
                            ),
                      selectedIcon:
                          snapshot.data == null || snapshot.data!.docs.isEmpty
                              ? const Icon(Icons.date_range)
                              : badge.Badge(
                                  badgeContent: Text(
                                    '${snapshot.data!.docs.length}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  badgeAnimation:
                                      const badge.BadgeAnimation.scale(),
                                  child: const Icon(Icons.date_range),
                                ),
                      label: 'MySID',
                    ),
                    const NavigationDestination(
                      icon: Icon(Icons.category_outlined),
                      selectedIcon: Icon(Icons.category),
                      label: 'Parts',
                    ),
                    const NavigationDestination(
                      icon: Icon(Icons.line_weight_outlined),
                      selectedIcon: Icon(Icons.line_weight),
                      label: 'Harga',
                    ),
                  ],
                );
              });
            }),
      ),
    );
  }
}
