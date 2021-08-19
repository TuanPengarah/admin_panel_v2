// ignore: import_of_legacy_library_into_null_safe
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'dart:io' show Platform;

class Print extends StatefulWidget {
  final String name;

  const Print({Key key, this.name}) : super(key: key);

  @override
  _PrintState createState() => _PrintState();
}

class _PrintState extends State<Print> {
  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];
  String _devicesMsg;
  BluetoothManager bluetoothManager = BluetoothManager.instance;

  void initPrinter() {
    _printerManager.startScan(Duration(seconds: 3));
    _printerManager.scanResults.listen((val) {
      print(val);
      if (!mounted) return;
      setState(() => _devices = val);
      if (_devices.isEmpty)
        setState(() => _devicesMsg = 'Tiada peranti berdekatan');
    });
  }

  Future<void> _startPrint(PrinterBluetooth printer) async {
    _printerManager.selectPrinter(printer);
    final result =
        await _printerManager.printTicket(await _ticket(PaperSize.mm80));
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(result.msg),
      ),
    );
  }

  Future<Ticket> _ticket(PaperSize paper) async {
    final ticket = Ticket(paper);
    // Image assets
    // final ByteData data = await rootBundle.load('assets/thermal.png');
    // final Uint8List bytes = data.buffer.asUint8List();
    // final Image image = decodeImage(bytes);
    // ticket.image(image);
    ticket.text(
      '${widget.name}',
      styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2),
      // linesAfter: 1,
    );
    ticket.cut();

    return ticket;
  }

  @override
  void initState() {
    if (Platform.isAndroid) {
      bluetoothManager.state.listen((val) {
        print('state = $val');
        if (!mounted) return;
        if (val == 12) {
          print('on');
          initPrinter();
        } else if (val == 10) {
          print('off');
          setState(() => _devicesMsg = 'Bluetooth di tutup!');
        }
      });
    } else {
      initPrinter();
    }

    super.initState();
  }

  @override
  void dispose() {
    _printerManager.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Print resit'),
        ),
        body: _devices.isEmpty
            ? Center(child: Text(_devicesMsg ?? ''))
            : ListView.builder(
                itemCount: _devices.length,
                itemBuilder: (c, i) {
                  return ListTile(
                    leading: Icon(Icons.print),
                    title: Text(_devices[i].name),
                    subtitle: Text(_devices[i].address),
                    onTap: () {
                      _startPrint(_devices[i]);
                    },
                  );
                },
              ));
  }
}
