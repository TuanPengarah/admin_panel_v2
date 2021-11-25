import 'package:admin_panel/home/controller/sparepart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/haptic_feedback.dart';
import '../../config/routes.dart';

class SparepartsCard extends StatelessWidget {
  final bool isAllRecord;
  final _sparepartController = Get.find<SparepartController>();

  SparepartsCard(this.isAllRecord);
  @override
  Widget build(BuildContext context) {
    return isAllRecord == false
        ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 18),
            width: Get.width,
            decoration: BoxDecoration(
              color: Get.theme.primaryColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: _content(),
          )
        : Card(
            elevation: Get.isDarkMode ? 0 : 10,
            margin: EdgeInsets.symmetric(horizontal: 18),
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
              color: isAllRecord == false
                  ? Colors.white60
                  : Get.theme.textTheme.bodyText1.color,
              fontSize: 18,
              letterSpacing: 1.5,
              wordSpacing: 2.8,
            ),
          ),
          SizedBox(height: 5),
          Obx(() {
            return Text(
              '${_sparepartController.totalSpareparts}',
              style: TextStyle(
                color: isAllRecord == false
                    ? Colors.white
                    : Get.theme.textTheme.bodyText1.color,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            );
          }),
          SizedBox(height: 10),
          Text(
            'Harga Keseluruhan: ',
            style: TextStyle(
              color: isAllRecord == false
                  ? Colors.white60
                  : Get.theme.textTheme.bodyText1.color,
              fontSize: 18,
              letterSpacing: 1.5,
              wordSpacing: 2.8,
            ),
          ),
          SizedBox(height: 5),
          Obx(() {
            return Text(
              'RM ${_sparepartController.totalPartsPrice.toStringAsFixed(2)}',
              style: TextStyle(
                color: isAllRecord == false
                    ? Colors.white
                    : Get.theme.textTheme.bodyText1.color,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            );
          }),
          SizedBox(height: 22),
          isAllRecord == false
              ? Container(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Haptic.feedbackClick();
                      Get.toNamed(MyRoutes.sparepartsAdd);
                    },
                    icon: Icon(Icons.add),
                    label: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Text('Tambah Spareparts'),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white24),
                      shadowColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                      elevation: MaterialStateProperty.all<double>(0),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
