import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:another_xlider/another_xlider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class MysidController extends GetxController {
  final repairLog = TextEditingController();
  final _data = Get.arguments;
  var percentage = 0.0.obs;
  var progressPercent = 0.0.obs;
  var editPercent = 0.0.obs;

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
    editPercent.value = percentage.value;
    final btnController = RoundedLoadingButtonController();
    final repairLogText = TextEditingController();
    var errorLog = false.obs;
    _checkLog(editPercent.value, repairLogText);
    await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
          avoidStatusBar: true,
          snapSpec: SnapSpec(snappings: [1, 1]),
          duration: Duration(milliseconds: 500),
          cornerRadius: 20,
          builder: (context, state) {
            return Material(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    TextField(
                      controller: repairLogText,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(labelText: 'Repair Log'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Error Log'),
                        SizedBox(width: 3),
                        Obx(() {
                          return Checkbox(
                            onChanged: (bool value) {
                              errorLog.value == false
                                  ? errorLog.value = true
                                  : errorLog.value = false;
                            },
                            value: errorLog.value,
                          );
                        }),
                      ],
                    ),
                    SizedBox(
                      height: 320,
                      width: 100,
                      child: FlutterSlider(
                        axis: Axis.vertical,
                        values: [editPercent.value],
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
                            color: Get.isDarkMode ? Colors.grey.shade900 : Colors.black12,
                          ),
                          activeTrackBar: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Get.theme.primaryColor,
                          ),
                        ),
                        onDragging: (index, lower, upper) {
                          editPercent.value = lower;
                          _checkLog(editPercent.value, repairLogText);
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Obx(() {
                      return Text(
                        '${editPercent.value}%',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
                    SizedBox(height: 20),
                    RoundedLoadingButton(
                      controller: btnController,
                      child: Text(
                        'Simpan',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        //   editPercent.value = editPercent.value / 100;
                        //   _data['Percent'] = editPercent.value;
                        //   checkPercent();
                        updateDB(
                          passRepairLog: repairLogText,
                          currentPercent: editPercent.value,
                          isError: errorLog.value,
                          btnController: btnController,
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Haptic.feedbackError();
                        Get.back();
                      },
                      child: Text(
                        'Tutup',
                        style: TextStyle(
                          color: Get.theme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    });
  }

  void _checkLog(double _value, TextEditingController crepairLog) {
    if (_value <= 1) {
      crepairLog.text = 'Pesanan diterima';
    } else if (_value <= 10) {
      crepairLog.text = 'Menunggu giliran';
    } else if (_value <= 15) {
      crepairLog.text = 'Memulakan proses diagnosis';
    } else if (_value <= 18) {
      crepairLog.text = 'Proses diagnosis selesai';
    } else if (_value <= 21) {
      crepairLog.text = 'Memulakan proses membaiki';
    } else if (_value <= 50) {
      crepairLog.text = 'Menyelaraskan sparepart baru kepada peranti anda';
    } else if (_value <= 65) {
      crepairLog.text = 'Semua alat sparepart baru berfungsi dengan baik';
    } else if (_value <= 70) {
      crepairLog.text = 'Memasang semula peranti anda';
    } else if (_value <= 80) {
      crepairLog.text = 'Melakukan proses diagnosis buat kali terakhir';
    } else if (_value <= 90) {
      crepairLog.text = 'Proses membaiki selesai';
    } else if (_value <= 95) {
      crepairLog.text = 'Pihak kami cuba untuk menghubungi anda';
    } else if (_value <= 98) {
      crepairLog.text = 'Maklumat telah diberitahu kepada anda';
    } else if (_value <= 100) {
      crepairLog.text = 'Selesai';
    }
  }

  Future<void> updateDB({
    @required double currentPercent,
    @required TextEditingController passRepairLog,
    @required bool isError,
    @required RoundedLoadingButtonController btnController,
  }) async {
    var firestore = FirebaseFirestore.instance;
    // bool isPayment = false;
    currentPercent = currentPercent / 100;
    print(currentPercent);
    // if (currentPercent == 1.0) {
    //   isPayment = true;
    // }
    // print(isPayment);
    Map<String, dynamic> repairLog = {
      'Repair Log': passRepairLog.text.toString(),
      'isError': isError,
      'timeStamp': FieldValue.serverTimestamp(),
    };
    Map<String, dynamic> updateStatus = {
      'Percent': currentPercent,
    };

    try {
      Future.delayed(Duration(seconds: 40), () async {
        btnController.error();
        Haptic.feedbackError();

        await Future.delayed(Duration(seconds: 2));
        Get.back();
        ShowSnackbar.error(
            'Repair Log', 'Kesalahan telah berlaku, sila check rangkaian internet anda!', true);
      });
      await firestore.collection('MyrepairID').doc(Get.parameters['id']).update(updateStatus);
      await firestore
          .collection('MyrepairID')
          .doc(Get.parameters['id'])
          .collection('repair log')
          .add(repairLog);

      btnController.success();
      Haptic.feedbackSuccess();

      _data['Percent'] = currentPercent;
      progressPercent.value = currentPercent;
      percentage.value = currentPercent * 100;
      await Future.delayed(Duration(seconds: 1));

      Get.back();
      ShowSnackbar.success('Repair Log', 'Maklumat repair log telah berjaya di kemaskini!', true);
    } on Exception catch (e) {
      btnController.error();
      Haptic.feedbackError();

      await Future.delayed(Duration(seconds: 2));
      Get.back();
      ShowSnackbar.error('Repair Log', 'Kesalahan telah berlaku: $e', true);
    }
  }
}
