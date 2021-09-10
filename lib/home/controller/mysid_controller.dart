import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:another_xlider/another_xlider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class MysidController extends GetxController {
  final repairLog = TextEditingController();
  final _data = Get.arguments;
  var percentage = 0.0.obs;
  var progressPercent = 0.0.obs;

  @override
  void onInit() {
    checkPercent();
    super.onInit();
  }

  void checkPercent() {
    progressPercent.value = _data['Percent'];
    var multiply = _data['Percent'] * 100;
    percentage.value = multiply;
    Future.delayed(Duration(milliseconds: 500), () {
      Haptic.feedbackSuccess();
    });
  }

  void setMysid(BuildContext context) async {
    await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
          snapSpec: SnapSpec(snappings: [1, 1]),
          builder: (context, state) {
            return Material(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Column(
                  children: [
                    // Text(
                    //   'Kemaskini Repair Log',
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(
                    //     fontSize: 20,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    SizedBox(
                      height: 380,
                      child: FlutterSlider(
                        axis: Axis.vertical,
                        values: [percentage.value],
                        max: 100,
                        min: 0,
                        handlerWidth: 60,
                        handlerHeight: 60,
                        selectByTap: false,
                        rtl: true,
                        trackBar: FlutterSliderTrackBar(
                          activeTrackBarHeight: 130,
                          inactiveTrackBarHeight: 130,
                          inactiveTrackBar: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black12,
                          ),
                          activeTrackBar: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Get.theme.primaryColor,
                          ),
                        ),
                        onDragging: (index, lower, upper) {
                          percentage.value = lower;
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Obx(() {
                      return Text(
                        '${percentage.value}%',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
                    SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(labelText: 'Repair Log'),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          onChanged: (bool value) {},
                          value: false,
                        ),
                        SizedBox(width: 3),
                        Text('Error Log'),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
    });
  }
}
