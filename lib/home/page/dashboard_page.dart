import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/graph/graph_controller.dart';
import 'package:admin_panel/graph/graph_monthly_sales.dart';
import 'package:admin_panel/home/controller/customer_controller.dart';
import 'package:admin_panel/home/controller/home_controller.dart';
import 'package:admin_panel/home/controller/sparepart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardPage extends GetResponsiveView<HomeController> {
  final _homeController = Get.find<HomeController>();
  final _graphController = Get.find<GraphController>();
  final _sparepartController = Get.find<SparepartController>();
  final _customerController = Get.find<CustomerController>();

  @override
  Widget builder() {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 450,
            color: Get.theme.primaryColor,
          ),
          RefreshIndicator(
            onRefresh: () async {
              Haptic.feedbackClick();
              await _graphController.getGraphFromFirestore();
              Haptic.feedbackSuccess();
            },
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  floating: false,
                  snap: false,
                  backgroundColor: Get.theme.primaryColor,
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
                                      'Laporan Jualan Bulanan',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Obx(() {
                                      return Text(
                                        'RM ${_graphController.jumlahBulanan.value}',
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
                          Card(
                            elevation: Get.isDarkMode ? 0 : 10,
                            margin: EdgeInsets.symmetric(horizontal: 18),
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
                                        Obx(() {
                                          return infoCard('Untung Kasar',
                                              'RM ${_graphController.untungKasar.value}');
                                        }),
                                        Obx(() {
                                          return infoCard('Untung Bersih',
                                              'RM ${_graphController.untungBersih.value}');
                                        }),
                                        Obx(() {
                                          return infoCard('Jumlah Modal',
                                              'RM ${_graphController.jumlahModal.value}');
                                        }),
                                        Obx(() {
                                          return infoCard('Jumlah Spareparts',
                                              '${_sparepartController.totalSpareparts.value}');
                                        }),
                                        Obx(() {
                                          return infoCard('Jumlah Pelanggan',
                                              '${_customerController.customerListRead.value}');
                                        }),
                                        Obx(() {
                                          return infoCard('Pending Job',
                                              '${_homeController.totalMysid.value}');
                                        }),
                                      ],
                                    ),
                                    SizedBox(height: 30),
                                    SizedBox(
                                      height: 40,
                                      width: 450,
                                      child: ElevatedButton.icon(
                                        onPressed: () =>
                                            _homeController.showBottomJosheet(),
                                        label: Text('Tambah Jobsheet'),
                                        icon: Icon(Icons.add),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
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
