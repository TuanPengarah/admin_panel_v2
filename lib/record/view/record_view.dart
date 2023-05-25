import 'package:admin_panel/cash_flow/widget/cashflow_widget_card.dart';
import 'package:admin_panel/graph/graph_controller.dart';
import 'package:admin_panel/home/widget/dashboard_card.dart';
import 'package:admin_panel/home/widget/sparepart_card.dart';
import 'package:admin_panel/record/widget/record_months.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecordView extends StatelessWidget {
  final _graphController = Get.find<GraphController>();

  RecordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'rekod',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rekod Keseluruhan'),
        ),
        body: FutureBuilder(
            future: _graphController.getGraph,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                children: [
                  const SizedBox(height: 30),
                  const CashFlowCard(true),
                  const SizedBox(height: 30),
                  DashboardCardMonths(DateTime.now().month - 1, false, false),
                  const SizedBox(height: 30),
                  SparepartsCard(true),
                  const SizedBox(height: 30),
                  const DashboardCardAll(false),
                  const SizedBox(height: 30),
                ],
              );
            }),
      ),
    );
  }
}
