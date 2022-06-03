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
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Text(
                'Rekod Data Bulan ${_graphController.checkMonthsMalay(bulan)}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: Get.mediaQuery.size.width >= 640 ? 15 : 5,
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
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Get.theme.colorScheme.onTertiary),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Get.theme.colorScheme.tertiary),
                        shadowColor: MaterialStateProperty.all<Color>(
                            Get.theme.colorScheme.tertiary),
                        elevation: MaterialStateProperty.all<double>(7),
                      ),
                    )
                  : isDashboard == true
                      ? Container()
                      : SizedBox(
                          // width: Get.width,
                          height: 45,
                          child: ElevatedButton(
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
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Get.theme.colorScheme.onTertiary),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Get.theme.colorScheme.tertiary),
                              shadowColor: MaterialStateProperty.all<Color>(
                                  Get.theme.colorScheme.tertiary),
                              elevation: MaterialStateProperty.all<double>(7),
                            ),
                            // icon: Icon(Icons.picture_as_pdf),
                            child: Center(
                              child: Text(
                                'Hasilkan Cash Flow Statement',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
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
              total <= 0.0
                  ? '--'
                  : '${NumberFormat.compactCurrency(decimalDigits: 2, symbol: 'RM').format(total)}',
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
