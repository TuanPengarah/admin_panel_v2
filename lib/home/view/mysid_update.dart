import 'package:admin_panel/home/controller/mysid_controller.dart';
import 'package:admin_panel/home/widget/mysid_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MysidUpdate extends StatelessWidget {
  final _mysidController = Get.put(MysidController());
  final _data = Get.arguments;
  final _params = Get.parameters;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Hero(
        tag: _params['id'],
        child: Scaffold(
          body: NestedScrollView(
            physics: BouncingScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  title: Text('Kemaskini Status'),
                  collapsedHeight: 300,
                  expandedHeight: 350,
                  snap: false,
                  pinned: false,
                  floating: true,
                  flexibleSpace: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(() {
                        return CircularPercentIndicator(
                          radius: 200.0,
                          lineWidth: 13.0,
                          animation: true,
                          arcType: ArcType.HALF,
                          arcBackgroundColor: Get.isDarkMode
                              ? Colors.blueGrey.shade700
                              : Colors.blue.shade600,
                          percent: _mysidController.progressPercent.value,
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Jumlah status\nkeselurahan",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${_mysidController.percentage.value.toStringAsFixed(0)}%',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.white,
                        );
                      }),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ];
            },
            body: MysidCard(params: _params, data: _data),
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: null,
            onPressed: () => _mysidController.setMysid(context),
            child: Icon(Icons.drive_file_rename_outline_outlined),
          ),
        ),
      ),
    );
  }
}
