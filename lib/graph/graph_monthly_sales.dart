import 'package:admin_panel/graph/graph_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
                    tooltipBgColor: Get.theme.colorScheme.surfaceVariant,
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        final flSpot = barSpot;
                        return LineTooltipItem(
                          flSpot.barIndex == 0 ? 'RM' : 'RM',
                          TextStyle(
                              color: flSpot.barIndex == 0
                                  ? Get.theme.colorScheme.tertiary
                                  : flSpot.barIndex == 1
                                      ? Colors.amber[900]
                                      : Get.theme.colorScheme.primary),
                          children: [
                            TextSpan(
                              text: flSpot.y.toStringAsFixed(0),
                              style: TextStyle(
                                color: flSpot.barIndex == 0
                                    ? Get.theme.colorScheme.tertiary
                                    : flSpot.barIndex == 1
                                        ? Colors.amber[900]
                                        : Get.theme.colorScheme.primary,
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
                  topTitles: AxisTitles(),
                  rightTitles: AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${_graphController.showMonthsGraph(value.toInt())}',
                            style: TextStyle(fontSize: 10),
                          );
                        }),
                    // rotateAngle: 40,
                    // getTitles: (value) {

                    // },
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      getTitlesWidget: (value, tilesMeta) {
                        return Text(
                          '${NumberFormat.compactCurrency(symbol: '').format(value)}',
                          style: TextStyle(fontSize: 10),
                        );
                      },
                      reservedSize: 30,
                      showTitles: true,
                      interval: 500 * 2.5.toDouble(),
                    ),
                  ),
                ),
                gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    verticalInterval: DateTime.now().month.toDouble() - 1 <= 0
                        ? 1
                        : DateTime.now().month.toDouble() - 1,
                    horizontalInterval: 500,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                          color: Get.isDarkMode ? Colors.white38 : Colors.grey,
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
                    color: Get.theme.colorScheme.tertiary,
                    dotData: FlDotData(show: true),
                    barWidth: 2,
                  ),
                  LineChartBarData(
                    isStrokeCapRound: true,
                    spots: _graphController.spotSupplier,
                    isCurved: true,
                    color: Colors.amber[900],
                    dotData: FlDotData(show: true),
                    barWidth: 2,
                  ),
                  LineChartBarData(
                    isStrokeCapRound: true,
                    spots: _graphController.spotUntungBersih,
                    isCurved: true,
                    color: Get.theme.colorScheme.primary,
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
