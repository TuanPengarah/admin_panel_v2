import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RepairHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _data = Get.arguments;
    return Hero(
      tag: _data[0],
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Sejarah Baiki'),
            ),
          ),
        ],
      ),
    );
  }
}
