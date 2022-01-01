import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/graph/graph_controller.dart';
import 'package:admin_panel/graph/graph_monthly_sales.dart';
import 'package:admin_panel/home/controller/home_controller.dart';
import 'package:admin_panel/home/widget/dashboard_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardPage extends GetResponsiveView<HomeController> {
  final _graphController = Get.find<GraphController>();
  @override
  Widget builder() {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          Haptic.feedbackClick();
          await _graphController.getGraphFromFirestore();
          Haptic.feedbackSuccess();
        },
        child: Stack(
          children: [
            Container(
              width: Get.width,
              height: 500,
              color: Get.theme.primaryColor,
            ),
            CustomScrollView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  floating: false,
                  snap: false,
                  backgroundColor: Get.theme.primaryColor,
                  actions: [
                    IconButton(
                      onPressed: () {
                        Haptic.feedbackClick();
                        Get.toNamed(MyRoutes.cashFlow);
                      },
                      icon: Icon(Icons.account_balance_wallet),
                    ),
                  ],
                  bottom: PreferredSize(
                    child: Container(),
                    preferredSize: Size(0, 20),
                  ),
                  expandedHeight: 380,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: screen.width,
                          decoration: BoxDecoration(
                            color: Get.theme.primaryColor,
                          ),
                          child: FutureBuilder(
                              future: _graphController.getGraph,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  );
                                }
                                return Column(
                                  children: [
                                    Text(
                                      'Laporan Jualan Bulan ${_graphController.checkMonthsMalay(DateTime.now().month - 1)}',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Obx(() {
                                      return Text(
                                        'RM ${_graphController.jumlahBulanan.value.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      );
                                    }),
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
                                              'Modal',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Column(
                        children: [
                          Hero(tag: 'rekod', child: DashboardCardAll(true)),
                          SizedBox(height: 30),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
