import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraphMonthlySales extends StatelessWidget {
  const GraphMonthlySales({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
          minX: 0,
          maxX: 11,
          minY: 0,
          maxY: 1000,
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  final flSpot = barSpot;
                  return LineTooltipItem(
                    'RM ',
                    TextStyle(
                      color: flSpot.barIndex == 0 ? Colors.white : Colors.amber,
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
              spots: [
                FlSpot(0, 340),
                FlSpot(1, 500),
                FlSpot(2, 450),
                FlSpot(3, 320),
                FlSpot(4, 400),
                FlSpot(5, 800),
                FlSpot(6, 790),
                FlSpot(7, 723),
              ],
              isCurved: true,
              colors: [
                Colors.white,
              ],
              dotData: FlDotData(show: true),
              barWidth: 3,
            ),
            LineChartBarData(
              spots: [
                FlSpot(0, 300),
                FlSpot(1, 400),
                FlSpot(2, 350),
                FlSpot(3, 220),
                FlSpot(4, 300),
                FlSpot(5, 700),
                FlSpot(6, 580),
                FlSpot(7, 410),
              ],
              isCurved: true,
              colors: [
                Colors.amber,
              ],
              dotData: FlDotData(show: true),
              barWidth: 3,
            ),
          ]),
    );
  }
}