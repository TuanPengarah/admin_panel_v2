import 'package:admin_panel/cash_flow/widget/cashflow_widgetCard.dart';
import 'package:admin_panel/home/widget/dashboard_card.dart';
import 'package:admin_panel/home/widget/sparepart_card.dart';
import 'package:admin_panel/record/widget/record_months.dart';
import 'package:flutter/material.dart';

class RecordView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'rekod',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rekod Keseluruhan'),
        ),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 30),
            CashFlowCard(true),
            const SizedBox(height: 30),
            DashboardCardMonths(),
            const SizedBox(height: 30),
            SparepartsCard(true),
            const SizedBox(height: 30),
            DashboardCardAll(false),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
