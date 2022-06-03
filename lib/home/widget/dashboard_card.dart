import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/home/controller/customer_controller.dart';
import 'package:admin_panel/home/controller/home_controller.dart';
import 'package:admin_panel/home/controller/sparepart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../config/haptic_feedback.dart';
import '../../graph/graph_controller.dart';

class DashboardCardAll extends StatelessWidget {
  final bool isDashboard;

  DashboardCardAll(this.isDashboard);
  @override
  Widget build(BuildContext context) {
    final _homeController = Get.find<HomeController>();
    final _graphController = Get.find<GraphController>();
    final _sparepartController = Get.find<SparepartController>();
    final _customerController = Get.find<CustomerController>();
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        // height: 500,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Text(
                isDashboard == true ? 'Rekod Data' : 'Rekod Data Keseluruhan',
                style: TextStyle(
                  fontSize: 19,
                  color: Get.theme.colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Wrap(
                spacing: Get.mediaQuery.size.width >= 640 ? 15 : 5,
                runSpacing: 15,
                children: [
                  Obx(() {
                    return infoCard('Untung Kasar',
                        '${NumberFormat.compactCurrency(decimalDigits: 2, symbol: 'RM').format(_graphController.untungKasar.value)}');
                  }),
                  Obx(() {
                    return infoCard('Untung Bersih',
                        '${NumberFormat.compactCurrency(decimalDigits: 2, symbol: 'RM').format(_graphController.untungBersih.value)}');
                  }),
                  Obx(() {
                    return infoCard('Jumlah Modal',
                        '${NumberFormat.compactCurrency(decimalDigits: 2, symbol: 'RM').format(_graphController.jumlahModal.value)}');
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
                    return infoCard(
                        'Pending Job', '${_homeController.totalMysid.value}');
                  }),
                ],
              ),
              SizedBox(height: 30),
              isDashboard == true
                  ? SizedBox(
                      height: 40,
                      width: 450,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Haptic.feedbackClick();
                          Get.toNamed(MyRoutes.allrecord);
                        },
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Get.theme.colorScheme.onTertiary),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Get.theme.colorScheme.tertiary),
                          shadowColor: MaterialStateProperty.all<Color>(
                              Get.theme.colorScheme.tertiary),
                          elevation: MaterialStateProperty.all<double>(7),
                        ),
                        label: Text('Lihat Kesemua Rekod'),
                        icon: Icon(Icons.list_alt_rounded),
                      ),
                    )
                  : Container(),
              const SizedBox(height: 20),
            ],
          ),
        ),
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
        color: Colors.black.withOpacity(0.08),
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
                color: Get.theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Text(
              total == 'RM 0.0' ? '--' : '$total',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Get.theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
