import 'package:admin_panel/cash_flow/controller/cashflow_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/haptic_feedback.dart';
import '../../config/snackbar.dart';

Future<dynamic> bottomSheetCashFlow(bool isEdit, String docID) {
  final _controller = Get.find<CashFlowController>();
  bool jualPhoneKe = false;
  bool sparepartKe = false;
  return Get.bottomSheet(
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  isEdit == false ? 'Tambah Cash Flow' : 'Edit Cash Flow',
                  style: TextStyle(
                    color: Get.theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _controller.hargaText,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                autofocus: false,
                decoration: InputDecoration(
                  label: Text('Harga'),
                  hintText: 'RM',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _controller.remarksText,
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
                    'Duit Masuk',
                  ),
                  Obx(() {
                    return Switch(
                      value: _controller.isModal.value,
                      onChanged: (newValue) {
                        _controller.isModal.value = newValue;
                      },
                    );
                  }),
                  Text(
                    'Duit Keluar',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Sparepart',
                    // style: TextStyle(color: Colors.green),
                  ),
                  Obx(() {
                    return Switch(
                      value: _controller.isSparepart.value,
                      onChanged: (newValue) {
                        _controller.isSparepart.value = newValue;
                        sparepartKe = newValue;
                        debugPrint('isSparepart = $sparepartKe');
                      },
                    );
                  }),
                  Text(
                    'Bukan Sparepart',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Jual Phone',
                  ),
                  Obx(() {
                    return Switch(
                      value: _controller.isJualPhone.value,
                      onChanged: (newValue) {
                        _controller.isJualPhone.value = newValue;
                        jualPhoneKe = newValue;
                        debugPrint('isJualPhone = $jualPhoneKe');
                      },
                    );
                  }),
                  Text(
                    'Bukan Jual Phone',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: Get.width,
                height: 48,
                child: ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Get.theme.colorScheme.onInverseSurface),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Get.theme.colorScheme.tertiary),
                    shadowColor: MaterialStateProperty.all<Color>(
                        Get.theme.colorScheme.tertiary),
                    elevation: MaterialStateProperty.all<double>(7),
                  ),
                  onPressed: () {
                    if (_controller.hargaText.text.isNotEmpty &&
                        _controller.remarksText.text.isNotEmpty) {
                      Get.back();
                      isEdit == false
                          ? _controller.addCashFlow()
                          : _controller.editCashFlow(
                              docID, jualPhoneKe, sparepartKe);
                    } else {
                      Haptic.feedbackError();

                      ShowSnackbar.error(
                        'Kesalahan telah berlaku',
                        'Sila isi semua maklumat untuk teruskan',
                        false,
                      );
                    }
                  },
                  child: Text(isEdit == false
                      ? 'Tambah Cash Flow'
                      : 'Simpan Perubahan'),
                ),
              ),
              const SizedBox(height: 10),
              isEdit == false
                  ? Container()
                  : Container(
                      alignment: Alignment.center,
                      child: TextButton.icon(
                        onPressed: () => _controller.deleteCashFlow(docID),
                        icon: Icon(Icons.delete),
                        label: Text('Buang'),
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Get.theme.colorScheme.error),
                        ),
                      ),
                    ),
              // TextButton(
              //   onPressed: () {
              //     Haptic.feedbackError();
              //     _controller.resetAdd();
              //     Get.back();
              //   },
              //   child: Text(
              //     'Batal',
              //     style: TextStyle(
              //       color: Get.theme.colorScheme.secondary,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      isDismissible: isEdit,
      backgroundColor: Get.theme.scaffoldBackgroundColor);
}
