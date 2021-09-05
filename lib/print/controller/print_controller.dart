import 'dart:io';
import 'dart:typed_data';
import 'package:admin_panel/config/snackbar.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:image/image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:get/get.dart';

class PrintController extends GetxController {
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

  Future<void> startPrintJobsheet(PrinterBluetooth printer, bool isNew) async {
    _printerManager.selectPrinter(printer);
    final result = await _printerManager
        .printTicket(await _jobsheetTicket(PaperSize.mm80, isNew));

    ShowSnackbar.notify('Status Print', result.msg);
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
      styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2),
      // linesAfter: 1,
    );
    ticket.text('Smarthone Repair', styles: PosStyles(align: PosAlign.center));
    ticket.text('Jalan Sentosa, Sungai Ramal Baru, 43000 Kajang',
        styles: PosStyles(align: PosAlign.center));
    ticket.text('Tel: 011-11426421', styles: PosStyles(align: PosAlign.center));
    ticket.text('af-fix.com',
        styles: PosStyles(align: PosAlign.center, underline: true));

    ticket.feed(1);
    ticket.text('Jobsheet',
        styles: PosStyles(align: PosAlign.center, bold: true));
    ticket.text('MySID: 2333242',
        styles: PosStyles(align: PosAlign.center, bold: true));
    ticket.feed(1);
    ticket.text('Nama: Abu', styles: PosStyles(align: PosAlign.left));
    ticket.text('Nombor tel: 0123234322',
        styles: PosStyles(align: PosAlign.left));
    ticket.text('Model: Nova 2i', styles: PosStyles(align: PosAlign.left));
    ticket.text('Kerosakkan: LCD', styles: PosStyles(align: PosAlign.left));
    ticket.text('Anggaran Harga: RM 180',
        styles: PosStyles(align: PosAlign.left));
    ticket.text('Remarks: *Lcd crack', styles: PosStyles(align: PosAlign.left));
    ticket.feed(1);
    ticket.qrcode('https://af-fix-database.web.app/mysid?id=125752',
        size: QRSize.Size5);

    ticket.feed(1);
    ticket.text(
      'Scan di sini untuk semak status baiki peranti anda!',
      styles: PosStyles(align: PosAlign.center),
    );
    if (isNew == true) {
      ticket.hr(len: 32);
      ticket.text(
        'Anda juga boleh login ke website kami untuk semak warranti dan  status baiki peranti',
        styles: PosStyles(align: PosAlign.center),
      );
      ticket.feed(1);
      ticket.text('Email: example@email.com');
      ticket.text('Password: 123456');
      ticket.feed(1);
      ticket.text('Terima Kasih!');
      ticket.cut();
    } else {
      ticket.feed(1);
      ticket.text('Terima Kasih!');
      ticket.cut();
    }

    return ticket;
  }
}