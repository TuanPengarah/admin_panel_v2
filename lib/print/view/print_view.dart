import 'package:admin_panel/print/controller/print_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrintView extends StatelessWidget {
  final _printController = Get.put(PrintController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Print'),
      ),
      body: GetBuilder<PrintController>(
        builder: (_) {
          if (_printController.devices.isEmpty) {
            return Center(
              child: Obx(
                () => Text(
                  _printController.devicesMsg.value ?? '',
                ),
              ),
            );
          }
          return Obx(
            () => _printController.isScan.value == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: _printController.devices.length,
                    itemBuilder: (context, i) {
                      var printer = _printController.devices[i];
                      return ListTile(
                          leading: Icon(Icons.print),
                          title: Text(printer.name),
                          subtitle: Text(printer.address),
                          onTap: () {
                            // return _printController.startPrintJobsheet(printer);
                            Get.dialog(
                              AlertDialog(
                                title: Text('Print untuk pengguna baru?'),
                                content: Text(
                                    'Adakah anda ingin memberitahu pengguna untuk fungsi e-waranti?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                       _printController
                                        .startPrintJobsheet(printer, false);
                                       Get.back();
                                    },
                                    child: Text('Tidak'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                       _printController
                                        .startPrintJobsheet(printer, true);
                                       Get.back();
                                    },
                                    child: Text('Ya'),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                  ),
          );
        },
      ),
    );
  }
}
