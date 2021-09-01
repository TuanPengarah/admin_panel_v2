import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/graph/graph_monthly_sales.dart';
import 'package:admin_panel/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardPage extends GetResponsiveView<HomeController> {
  final _homeController = Get.find<HomeController>();
  @override
  Widget builder() {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              width: double.infinity,
              height: 300,
              color:
                  Get.isDarkMode ? Color(0xff131313) : Get.theme.primaryColor),
          RefreshIndicator(
            onRefresh: () async {
              Haptic.feedbackClick();
              await Future.delayed(Duration(seconds: 2));
              Haptic.feedbackSuccess();
            },
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  title: Text('Dashboard'),
                  floating: true,
                  backgroundColor: Get.isDarkMode
                      ? Color(0xff131313)
                      : Get.theme.primaryColor,
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Column(
                        children: [
                          SizedBox(
                            height: screen.isPhone
                                ? screen.height + 100
                                : screen.height,
                            child: Stack(
                              children: [
                                Container(
                                  height: 400,
                                  width: screen.width,
                                  decoration: BoxDecoration(
                                    color: Get.isDarkMode
                                        ? Color(0xff131313)
                                        : Get.theme.primaryColor,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Laporan Jualan Bulanan',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'RM 723',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0, horizontal: 10),
                                        child: Container(
                                          height: 220,
                                          child: GraphMonthlySales(),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: 20,
                                                width: 20,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                'Harga Jual',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                height: 20,
                                                width: 20,
                                                color: Colors.amber,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                'Harga Supplier',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 330,
                                  left: screen.isPhone
                                      ? 20
                                      : screen.isTablet
                                          ? 60
                                          : screen.isDesktop
                                              ? 300
                                              : 20,
                                  right: screen.isPhone
                                      ? 20
                                      : screen.isTablet
                                          ? 60
                                          : screen.isDesktop
                                              ? 300
                                              : 20,
                                  child: Card(
                                    elevation: Get.isDarkMode ? 0 : 10,
                                    child: Container(
                                      // height: 500,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Rekod Data',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            Wrap(
                                              spacing: 15,
                                              runSpacing: 15,
                                              children: [
                                                infoCard(
                                                    'Untung Kasar', 'RM 5443'),
                                                infoCard(
                                                    'Untung Bersih', 'RM 4354'),
                                                infoCard('Modal Supplier',
                                                    'RM 3034'),
                                                infoCard(
                                                    'Jumlah Spareparts', '23'),
                                              ],
                                            ),
                                            SizedBox(height: 30),
                                            SizedBox(
                                              height: 40,
                                              width: 450,
                                              child: ElevatedButton.icon(
                                                onPressed: () => _homeController
                                                    .showBottomJosheet(),
                                                label: Text('Tambah Jobsheet'),
                                                icon: Icon(Icons.add),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container infoCard(
    String title,
    String total,
  ) {
    return Container(
        width: 120,
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Get.isDarkMode ? Colors.black12 : Colors.grey.shade200,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$title',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                total == '0' ? '--' : '$total',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ));
  }
}
