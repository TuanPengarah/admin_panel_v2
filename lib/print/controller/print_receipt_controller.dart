import 'dart:io';

import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:get/get.dart';

class PrintReceiptController extends GetxController {
  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> devices = [];
  var devicesMsg = ''.obs;
  var isScan = true.obs;
  BluetoothManager bluetoothManager = BluetoothManager.instance;

  @override
  void onInit() {
    checkDevicesPrinter();
    super.onInit();
  }

  @override
  void onClose() {
    _printerManager.stopScan();
    super.onClose();
  }

  void checkDevicesPrinter() {
    if (Platform.isAndroid) {
      bluetoothManager.state.listen((val) {
        print('state = $val');
        if (val == 12) {
          print('on');
          initPrinter();
        } else if (val == 10) {
          print('off');
          devicesMsg.value = 'Bluetooth di tutup!';
          update();
        }
      });
    } else {
      initPrinter();
    }
  }

  void initPrinter() {
    isScan.value = true;
    _printerManager.startScan(Duration(seconds: 3));
    Future.delayed(Duration(seconds: 3), () => isScan.value = false);
    _printerManager.scanResults.listen((val) {
      print(val);
      devices = val;
      update();
      if (devices.isEmpty) {
        devicesMsg.value = 'Tiada peranti berdekatan';
        update();
      }
    });
  }

  // Future<void> startPrintJobsheet(PrinterBluetooth printer, bool isNew) async {
  //   _printerManager.selectPrinter(printer);
  //   final result = await _printerManager.printTicket(await _jobsheetTicket(PaperSize.mm80, isNew));
  //
  //   ShowSnackbar.notify('Status Print', result.msg);
  //   Haptic.feedbackSuccess();
  // }

}
