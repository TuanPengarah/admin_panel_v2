import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/graph/graph_monthly_sales.dart';
import 'package:admin_panel/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardPage extends GetResponsiveView<HomeController> {
  @override
  Widget builder() {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              width: double.infinity,
              height: 300,
              color: Get.theme.primaryColor),
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
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Column(
                        children: [
                          SizedBox(
                            height: screen.isPhone
                                ? screen.height + 120
                                : screen.height,
                            child: Stack(
                              children: [
                                Container(
                                  height: 400,
                                  width: screen.width,
                                  decoration: BoxDecoration(
                                    color: Get.theme.primaryColor,
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
                                    elevation: 10,
                                    child: Container(
                                      // height: 500,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Rekod Jumlah Keseluruhan',
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
                                                infoCard(),
                                                infoCard(),
                                                infoCard(),
                                                infoCard(),
                                                infoCard(),
                                                infoCard(),
                                              ],
                                            ),
                                            SizedBox(height: 30),
                                            SizedBox(
                                              height: 40,
                                              width: 450,
                                              child: ElevatedButton.icon(
                                                onPressed: () {
                                                  Haptic.feedbackClick();
                                                },
                                                label: Text('Add New Jobsheet'),
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
                          SizedBox(height: 120),
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

  Container infoCard() {
    return Container(
      width: 100,
      height: 130,
      color: Colors.amber,
    );
  }
}
