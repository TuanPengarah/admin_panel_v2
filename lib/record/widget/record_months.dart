import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../graph/graph_controller.dart';

class DashboardCardMonths extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _graphController = Get.find<GraphController>();
    return Card(
      elevation: Get.isDarkMode ? 0 : 10,
      margin: EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        // height: 500,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Text(
                'Rekod Data Bulan ${_graphController.checkMonthsMalay(DateTime.now().month - 1)}',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: [
                  Obx(() {
                    return infoCard(
                        'Untung Kasar', _graphController.jumlahBulanan.value);
                  }),
                  infoCard('Untung Bersih',
                      _graphController.getMonthsUntungBersih()),
                  infoCard(
                      'Jumlah Modal', _graphController.getMonthsHargajual()),
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Container infoCard(
    String title,
    double total,
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
                color: Get.isDarkMode ? Colors.white : Colors.grey.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Text(
              total <= 0.0 ? '--' : 'RM ${total.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Get.isDarkMode ? Colors.white : Colors.grey,
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
