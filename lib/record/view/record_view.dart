import 'package:admin_panel/home/widget/dashboard_card.dart';
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
            DashboardCardMonths(),
            const SizedBox(height: 30),
            DashboardCardAll(false),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
