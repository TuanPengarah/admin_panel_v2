import 'package:admin_panel/home/controller/sparepart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/haptic_feedback.dart';
import '../../config/routes.dart';

class SparepartsCard extends StatelessWidget {
  final bool isAllRecord;
  final _sparepartController = Get.find<SparepartController>();

  SparepartsCard(this.isAllRecord, {super.key});
  @override
  Widget build(BuildContext context) {
    return isAllRecord == false
        ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 18),
            width: Get.width,
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(30),
            ),
            child: _content(),
          )
        : Card(
            margin: const EdgeInsets.symmetric(horizontal: 18),
            child: _content(),
          );
  }

  Padding _content() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jumlah Spareparts: ',
            style: TextStyle(
              color: Get.theme.colorScheme.secondary,
              fontSize: 18,
              letterSpacing: 1.5,
              wordSpacing: 2.8,
            ),
          ),
          const SizedBox(height: 5),
          Obx(() {
            return Text(
              '${_sparepartController.totalSpareparts}',
              style: TextStyle(
                color: Get.theme.colorScheme.secondary,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            );
          }),
          const SizedBox(height: 10),
          Text(
            'Harga Keseluruhan: ',
            style: TextStyle(
              color: Get.theme.colorScheme.secondary,
              fontSize: 18,
              letterSpacing: 1.5,
              wordSpacing: 2.8,
            ),
          ),
          const SizedBox(height: 5),
          Obx(() {
            return Text(
              'RM ${_sparepartController.totalPartsPrice.toStringAsFixed(2)}',
              style: TextStyle(
                color: Get.theme.colorScheme.secondary,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            );
          }),
          const SizedBox(height: 22),
          isAllRecord == false
              ? Container(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Haptic.feedbackClick();
                      Get.toNamed(MyRoutes.sparepartsAdd);
                    },
                    icon: const Icon(Icons.add),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Get.theme.colorScheme.onTertiary),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Get.theme.colorScheme.tertiary),
                      shadowColor: MaterialStateProperty.all<Color>(
                          Get.theme.colorScheme.tertiary),
                      elevation: MaterialStateProperty.all<double>(7),
                    ),
                    label: const Padding(
                      padding: EdgeInsets.all(13.0),
                      child: Text('Tambah Spareparts'),
                    ),
                  ),
                )
              : Container(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
