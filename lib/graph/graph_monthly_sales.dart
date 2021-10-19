import 'package:admin_panel/graph/graph_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GraphMonthlySales extends StatelessWidget {
  final _graphController = Get.find<GraphController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GraphController>(
      assignId: true,
      builder: (logic) {
        return Padding(
          padding: const EdgeInsets.only(right: 30.0),
          child: LineChart(
            LineChartData(
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: _graphController.untungKasar.value.toDouble(),
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        final flSpot = barSpot;
                        return LineTooltipItem(
                          flSpot.barIndex == 0 ? 'Harga jual: RM ' : 'Modal: RM ',
                          TextStyle(
                            color: flSpot.barIndex == 0 ? Colors.white : Colors.amber,
                          ),
                          children: [
                            TextSpan(
                              text: flSpot.y.toStringAsFixed(0),
                              style: TextStyle(
                                color: flSpot.barIndex == 0 ? Colors.white : Colors.amber,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      }).toList();
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: SideTitles(
                    showTitles: true,
                    getTitles: (value) {
                      switch (value.toInt()) {
                        case 0:
                          return 'JAN';
                        // case 1:
                        //   return 'FEB';
                        case 2:
                          return 'MAR';
                        // case 3:
                        //   return 'APR';
                        case 4:
                          return 'MAY';
                        // case 5:
                        //   return 'JUN';
                        case 6:
                          return 'JUL';
                        // case 7:
                        //   return 'AUG';
                        case 8:
                          return 'SEP';
                        // case 9:
                        //   return 'OCT';
                        case 10:
                          return 'NOV';
                        // case 11:
                        //   return 'DEC';
                      }

                      return '';
                    },
                    getTextStyles: (_, __) => TextStyle(color: Colors.white),
                    margin: 3,
                  ),
                  leftTitles: SideTitles(
                      showTitles: true,
                      getTitles: (_) {
                        return '';
                      }),
                ),
                gridData: FlGridData(
                    show: false,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.white,
                        strokeWidth: 0.5,
                      );
                    }),
                borderData: FlBorderData(
                  show: false,
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: _graphController.spotSupplier,
                    isCurved: true,
                    colors: [
                      Colors.amber,
                    ],
                    dotData: FlDotData(show: true),
                    barWidth: 3,
                  ),
                  LineChartBarData(
                    spots: _graphController.spotJual,
                    isCurved: true,
                    colors: [
                      Colors.white,
                    ],
                    dotData: FlDotData(show: true),
                    barWidth: 3,
                  ),
                ]),
          ),
        );
      },
    );
  }
}
