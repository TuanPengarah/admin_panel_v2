import 'package:admin_panel/home/controller/mysid_controller.dart';
import 'package:admin_panel/home/widget/mysid_card.dart';
import 'package:admin_panel/sms/controller/sms_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../config/routes.dart';

class MysidUpdate extends StatelessWidget {
  final _mysidController = Get.put(MysidController());
  final _data = Get.arguments;
  final _params = Get.parameters;

  MysidUpdate({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Hero(
        tag: _params['id'].toString(),
        child: Scaffold(
          body: NestedScrollView(
            physics: const BouncingScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  title: const Text('Kemaskini Status'),
                  expandedHeight: 350,
                  snap: false,
                  pinned: true,
                  floating: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: FittedBox(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 100),
                          Obx(() {
                            return CircularPercentIndicator(
                              radius: 100.0,
                              lineWidth: 13.0,
                              animation: true,
                              arcType: ArcType.HALF,
                              arcBackgroundColor:
                                  Get.theme.colorScheme.surfaceVariant,
                              percent: _mysidController.progressPercent.value,
                              center: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Jumlah status\nkeselurahan",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${_mysidController.percentage.value.toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      color: Get.theme.colorScheme.secondary,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: Get.theme.colorScheme.secondary,
                            );
                          }),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    Obx(
                      () => _mysidController.percentage.value >= 90
                          ? IconButton(
                              onPressed: () {
                                final mysidController =
                                    Get.put(SMSController());

                                mysidController.recipientText.text =
                                    '6${_data['No Phone']}';
                                mysidController.messageText.text =
                                    'Peranti (Mysid: ${_params['id']}) anda telah siap dibaiki. Anda boleh pickup peranti anda sekarang! Harap maklum dan terima kasih!';
                                Get.toNamed(MyRoutes.smsView);
                              },
                              icon: const Icon(Icons.sms),
                            )
                          : const SizedBox(),
                    ),
                  ],
                ),
              ];
            },
            body: MysidCard(
                params: {'id': _params['id'].toString()}, data: _data),
          ),
          floatingActionButton: FloatingActionButton.extended(
            isExtended: false,
            heroTag: null,
            onPressed: () => _mysidController.setMysid(context),
            label: const Text('Kemaskini'),
            icon: const Icon(Icons.drive_file_rename_outline_outlined),
          ),
        ),
      ),
    );
  }
}
