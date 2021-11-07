import 'package:admin_panel/cash_flow/controller/cashflow_controller.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CashFlowAdd extends GetView<CashFlowController> {
  const CashFlowAdd({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {
          Get.dialog(
            AlertDialog(
              title: Text(
                'Tambah Cash Flow',
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: controller.hargaText,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    decoration: InputDecoration(
                      label: Text('Harga'),
                      hintText: 'RM',
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: controller.remarksText,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                        label: Text('Remarks'),
                        hintText: 'cth: Pertol, Duit Tips...'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Income',
                        // style: TextStyle(color: Colors.green),
                      ),
                      Obx(() {
                        return Switch(
                          value: controller.isModal.value,
                          onChanged: (newValue) {
                            controller.isModal.value = newValue;
                            print(controller.isModal.value);
                          },
                        );
                      }),
                      Text(
                        'Expense',
                        // style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Haptic.feedbackError();
                      controller.resetAdd();
                    },
                    child: Text(
                      'Batal',
                      style: TextStyle(
                        color: Colors.amber[900],
                      ),
                    )),
                TextButton(
                    onPressed: () {
                      if (controller.hargaText.text.isNotEmpty &&
                          controller.remarksText.text.isNotEmpty) {
                        Get.back();
                        controller.addCashFlow();
                      } else {
                        Haptic.feedbackError();
                        ShowSnackbar.error('Kesalahan telah berlaku',
                            'Sila isi semua maklumat untuk teruskan', false);
                      }
                    },
                    child: Text('Tambah')),
              ],
            ),
            barrierDismissible: false,
          );
        },
        borderRadius: BorderRadius.circular(100),
        child: Ink(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            color: Get.isDarkMode ? Colors.grey[900] : Colors.grey,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
