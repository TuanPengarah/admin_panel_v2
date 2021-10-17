import 'dart:io';
import 'dart:typed_data';

import 'package:admin_panel/POS/controller/payment_controller.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:get/get.dart';
import 'package:image/image.dart';

class PrintController extends GetxController {
  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> devices = [];
  var devicesMsg = ''.obs;
  var isScan = true.obs;
  BluetoothManager bluetoothManager = BluetoothManager.instance;
  final _data = Get.arguments;

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

  Future<void> startPrintJobsheet(PrinterBluetooth printer, bool isNew, bool isReceipt) async {
    _printerManager.selectPrinter(printer);

    if (isReceipt == true) {
      final receipt =
          await _printerManager.printTicket(await _receiptTicket(PaperSize.mm80, isNew));
      ShowSnackbar.notify('Print Resit', receipt.msg);
    } else {
      final jobsheet =
          await _printerManager.printTicket(await _jobsheetTicket(PaperSize.mm80, isNew));
      ShowSnackbar.notify('Print Jobsheet', jobsheet.msg);
    }
    Haptic.feedbackSuccess();
  }

  Future<Ticket> _jobsheetTicket(PaperSize paper, bool isNew) async {
    final ticket = Ticket(paper);
    // Image assets
    final ByteData data = await rootBundle.load('assets/images/thermal.png');
    final Uint8List bytes = data.buffer.asUint8List();
    final Image image = decodeImage(bytes);
    ticket.image(image);
    ticket.text(
      'AF-FIX',
      styles:
          PosStyles(align: PosAlign.center, height: PosTextSize.size2, width: PosTextSize.size2),
      // linesAfter: 1,
    );
    ticket.text('Smarthone Repair', styles: PosStyles(align: PosAlign.center));
    ticket.text('Lot 8418, Jalan Sentosa, Sungai Ramal Baru, 43000 Kajang',
        styles: PosStyles(align: PosAlign.center));
    ticket.text('Tel: 011-11426421', styles: PosStyles(align: PosAlign.center));
    ticket.text('af-fix.com', styles: PosStyles(align: PosAlign.center, underline: true));

    ticket.feed(1);
    ticket.text('Jobsheet', styles: PosStyles(align: PosAlign.center, bold: true));
    ticket.text('MySID: ${_data['mysid']}', styles: PosStyles(align: PosAlign.center, bold: true));
    ticket.feed(1);
    ticket.text('Nama: ${_data['nama']}', styles: PosStyles(align: PosAlign.left));
    ticket.text('Nombor tel: ${_data['noTel']}', styles: PosStyles(align: PosAlign.left));
    ticket.text('Model: ${_data['model']}', styles: PosStyles(align: PosAlign.left));
    ticket.text('Kerosakkan: ${_data['kerosakkan']}', styles: PosStyles(align: PosAlign.left));
    ticket.text('Anggaran Harga: RM${_data['price']}', styles: PosStyles(align: PosAlign.left));
    ticket.text('Remarks: *${_data['remarks']}', styles: PosStyles(align: PosAlign.left));
    ticket.feed(1);
    ticket.qrcode('https://af-fix-database.web.app/mysid?id=${_data['mysid']}', size: QRSize.Size5);

    ticket.feed(1);
    ticket.text(
      'Scan di sini untuk semak status baiki peranti anda!',
      styles: PosStyles(align: PosAlign.center),
    );
    if (isNew == true) {
      ticket.hr(len: 32);
      ticket.text(
        'Anda juga boleh auth ke website kami untuk semak waranti dan   status baiki peranti',
        styles: PosStyles(align: PosAlign.center),
      );
      ticket.feed(1);
      ticket.text('Email: ${_data['email']}');
      ticket.text('Password: 123456');
      ticket.feed(1);
      ticket.text(
        'Terima Kasih!',
        styles: PosStyles(align: PosAlign.center),
      );
      ticket.cut();
    } else {
      ticket.feed(1);
      ticket.text(
        'Terima Kasih!',
        styles: PosStyles(align: PosAlign.center),
      );
      ticket.cut();
    }

    return ticket;
  }

  Future<Ticket> _receiptTicket(PaperSize paper, bool isNew) async {
    final payment = Get.find<PaymentController>();
    final ticket = Ticket(paper);
    // Image assets
    final ByteData data = await rootBundle.load('assets/images/thermal.png');
    final Uint8List bytes = data.buffer.asUint8List();
    final Image image = decodeImage(bytes);
    ticket.image(image);
    ticket.text(
      'AF-FIX',
      styles:
          PosStyles(align: PosAlign.center, height: PosTextSize.size2, width: PosTextSize.size2),
      // linesAfter: 1,
    );
    ticket.text('Smarthone Repair', styles: PosStyles(align: PosAlign.center));
    ticket.text('Lot 8418, Jalan Sentosa, Sungai Ramal Baru, 43000 Kajang',
        styles: PosStyles(align: PosAlign.center));
    ticket.text('Tel: 011-11426421', styles: PosStyles(align: PosAlign.center));
    ticket.text('af-fix.com', styles: PosStyles(align: PosAlign.center, underline: true));

    ticket.feed(1);
    for (var i = 0; i < payment.bills.length; i++) {
      ticket.text('${payment.bills[i]['title']}');
      ticket.row(
        [
          PosColumn(text: '(${payment.bills[i]['waranti']})', width: 6),
          PosColumn(
              text: 'RM ${payment.bills[i]['harga'].toString()}',
              styles: PosStyles(underline: true),
              width: 6)
        ],
      );
    }
    ticket.feed(1);
    ticket.row([
      PosColumn(text: 'Jumlah: ', width: 6, styles: PosStyles(bold: true)),
      PosColumn(
          text: 'RM ${payment.totalBillsPrice.value}', width: 6, styles: PosStyles(bold: true)),
    ]);
    if (isNew == true) {
      ticket.feed(1);
      ticket.qrcode('https://af-fix-database.web.app/', size: QRSize.Size5);

      ticket.feed(1);
      ticket.text(
        'Scan sini untuk semak status    waranti anda!',
        styles: PosStyles(align: PosAlign.center),
      );
      ticket.feed(1);
      ticket.text(
        'Terima Kasih!',
        styles: PosStyles(align: PosAlign.center),
      );
      ticket.cut();
    } else {
      ticket.feed(1);
      ticket.text(
        'Terima Kasih!',
        styles: PosStyles(align: PosAlign.center),
      );
      ticket.cut();
    }
    return ticket;
  }
}
