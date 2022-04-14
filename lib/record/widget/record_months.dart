import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../config/haptic_feedback.dart';
import '../../config/routes.dart';
import '../../graph/graph_controller.dart';

class DashboardCardMonths extends StatelessWidget {
  final int bulan;
  final bool isSpecific;
  final bool isDashboard;
  DashboardCardMonths(this.bulan, this.isSpecific, this.isDashboard);
  @override
  Widget build(BuildContext context) {
    final _graphController = Get.find<GraphController>();
    return Card(
      elevation: Get.isDarkMode ? 0 : 10,
      margin: EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Text(
                'Rekod Data Bulan ${_graphController.checkMonthsMalay(bulan)}',
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
                  infoCard(
                      'Untung Kasar', _graphController.getUntungKasar(bulan)),
                  infoCard(
                      'Untung Bersih', _graphController.getUntungBersih(bulan)),
                  infoCard('Jumlah Modal',
                      _graphController.getMonthsHargajual(bulan).toDouble()),
                ],
              ),
              SizedBox(height: 30),
              isSpecific == false
                  ? ElevatedButton.icon(
                      onPressed: () => Get.toNamed(MyRoutes.monthlyRecord),
                      label: Text('Lihat Rekod Mengikut Bulan '),
                      icon: Icon(Icons.read_more),
                    )
                  : isDashboard == true
                      ? Container()
                      : ElevatedButton.icon(
                          onPressed: () {
                            var payload = {
                              'bulan': bulan,
                              'untungKasar':
                                  _graphController.getUntungKasar(bulan),
                              'untungBersih':
                                  _graphController.getUntungBersih(bulan),
                              'modal': _graphController
                                  .getMonthsHargajual(bulan)
                                  .toDouble(),
                            };
                            Haptic.feedbackClick();
                            Get.toNamed(MyRoutes.cashflowStatement,
                                arguments: payload);
                          },
                          icon: Icon(Icons.picture_as_pdf),
                          label: Text('Hasilkan Cash Flow Statement')),
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
              total <= 0.0
                  ? '--'
                  : '${NumberFormat.compactCurrency(decimalDigits: 2, symbol: 'RM').format(total)}',
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
