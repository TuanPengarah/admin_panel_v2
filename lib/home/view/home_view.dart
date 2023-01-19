import 'package:admin_panel/config/get_route_export.dart';
import 'package:admin_panel/home/controller/home_controller.dart';
import 'package:admin_panel/home/page/customer_page.dart';
import 'package:admin_panel/home/page/dashboard_page_v2.dart';
import 'package:admin_panel/home/page/mysid_page.dart';
import 'package:admin_panel/home/page/sparepart_page.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            labelTextStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
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
                      icon: snapshot.data == null ||
                              snapshot.data.docs.length == 0
                          ? Icon(Icons.date_range_outlined)
                          : Badge(
                              badgeContent: Text('${snapshot.data.docs.length}',
                                  style: TextStyle(color: Colors.white)),
                              child: Icon(Icons.date_range_outlined),
                              animationType: BadgeAnimationType.scale,
                              animationDuration: Duration(milliseconds: 200),
                            ),
                      selectedIcon: snapshot.data == null ||
                              snapshot.data.docs.length == 0
                          ? Icon(Icons.date_range)
                          : Badge(
                              badgeContent: Text(
                                '${snapshot.data.docs.length}',
                                style: TextStyle(color: Colors.white),
                              ),
                              child: Icon(Icons.date_range),
                              animationType: BadgeAnimationType.scale,
                              animationDuration: Duration(milliseconds: 200),
                            ),
                      label: 'MySID',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.category_outlined),
                      selectedIcon: Icon(Icons.category),
                      label: 'Parts',
                    ),
                    NavigationDestination(
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
