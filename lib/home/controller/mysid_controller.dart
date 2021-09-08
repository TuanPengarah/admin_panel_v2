import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class MysidController extends GetxController {
  void controllMysid({
    @required BuildContext context,
    @required String nama,
    @required String model,
    @required String password,
    @required String remarks,
  }) async {
    await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
          duration: Duration(milliseconds: 400),
          // snapSpec: SnapSpec(snappings: [1, 1]),
          snapSpec: const SnapSpec(
            snap: true,
            snappings: [1.4, 1.7, 1.0],
            positioning: SnapPositioning.relativeToSheetHeight,
          ),
          color: Theme.of(context).canvasColor,
          elevation: 8,
          builder: (context, state) {
            return SizedBox(
              width: Get.width,
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Kemaskini Status',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '$nama | $model',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Maklumat Kerosakkan: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text('Model: $model',
                                style: TextStyle(color: Colors.grey)),
                            Text('Password: $password',
                                style: TextStyle(color: Colors.grey)),
                            Text('Catatan: $remarks',
                                style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 10),
                            SizedBox(
                              width: Get.width,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  'Repair Log',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    });
  }
}
