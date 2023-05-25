import 'package:admin_panel/graph/graph_controller.dart';
import 'package:admin_panel/record/widget/record_months.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class MonthlyRecordView extends GetView<GraphController> {
  const MonthlyRecordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekod Bulanan'),
      ),
      body: ListView.builder(
          itemCount: controller.getTotalMonth(),
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: DashboardCardMonths(i, true, false),
            );
          }),
    );
  }
}
