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
          padding: const EdgeInsets.only(right: 40.0, left: 30),
          child: LineChart(
            LineChartData(
                // minX: 0,
                // minY: 0,
                lineTouchData: LineTouchData(
                  enabled: true,
                  // touchCallback: (touchEvent, response) {
                  //   print(touchEvent.localPosition);
                  // },
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        final flSpot = barSpot;
                        return LineTooltipItem(
                          flSpot.barIndex == 0 ? 'RM' : 'RM',
                          TextStyle(
                            color: flSpot.barIndex == 0
                                ? Colors.white
                                : Colors.amber,
                          ),
                          children: [
                            TextSpan(
                              text: flSpot.y.toStringAsFixed(0),
                              style: TextStyle(
                                color: flSpot.barIndex == 0
                                    ? Colors.white
                                    : Colors.amber,
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
                  topTitles: SideTitles(showTitles: false),
                  rightTitles: SideTitles(showTitles: false),
                  bottomTitles: SideTitles(
                    textAlign: TextAlign.start,
                    showTitles: true,
                    interval: 1,
                    // rotateAngle: 40,
                    getTitles: (value) {
                      switch (value.toInt()) {
                        case 0:
                          return 'JAN';
                        case 1:
                          return value > 10 ? '' : 'FEB';
                        case 2:
                          return 'MAC';
                        case 3:
                          return value > 10 ? '' : 'APR';
                        case 4:
                          return 'MEI';
                        case 5:
                          return value > 10 ? '' : 'JUN';
                        case 6:
                          return 'JUL';
                        case 7:
                          return value > 10 ? '' : 'AUG';
                        case 8:
                          return 'SEP';
                        case 9:
                          return value > 10 ? '' : 'OCT';
                        case 10:
                          return 'NOV';
                        case 11:
                          return value > 10 ? '' : 'DEC';
                      }

                      return '';
                    },
                    getTextStyles: (_, __) => TextStyle(color: Colors.white),
                    margin: 3,
                  ),
                  leftTitles: SideTitles(
                    reservedSize: 30,
                    textAlign: TextAlign.start,
                    showTitles: true,
                    interval: 1000 * 2.5.toDouble(),
                    getTextStyles: (_, __) =>
                        TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
                gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    verticalInterval: DateTime.now().month.toDouble() - 1,
                    horizontalInterval: 500,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                          color: Colors.white38,
                          strokeWidth: 2,
                          dashArray: [4]);
                    }),
                borderData: FlBorderData(
                  show: false,
                ),
                lineBarsData: [
                  LineChartBarData(
                    isStrokeCapRound: true,
                    spots: _graphController.spotJual,
                    isCurved: true,
                    colors: [
                      Colors.white,
                    ],
                    dotData: FlDotData(show: true),
                    barWidth: 2,
                  ),
                  LineChartBarData(
                    isStrokeCapRound: true,
                    spots: _graphController.spotSupplier,
                    isCurved: true,
                    colors: [
                      Colors.amber,
                    ],
                    dotData: FlDotData(show: true),
                    barWidth: 2,
                  ),
                ]),
          ),
        );
      },
    );
  }
}
