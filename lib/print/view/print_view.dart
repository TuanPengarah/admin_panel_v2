// import 'package:admin_panel/print/controller/print_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class PrintView extends StatelessWidget {
//   final _printController = Get.put(PrintController());
//   final _data = Get.arguments;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_data['isReceipt'] == false || _data['isReceipt'] == null
//             ? 'Print Jobsheet'
//             : 'Print Resit'),
//       ),
//       body: GetBuilder<PrintController>(
//         builder: (_) {
//           if (_printController.devices.isEmpty) {
//             return Center(
//               child: Obx(
//                 () => Text(
//                   _printController.devicesMsg.value ?? '',
//                 ),
//               ),
//             );
//           }
//           return Obx(
//             () => _printController.isScan.value == true
//                 ? Center(
//                     child: CircularProgressIndicator(),
//                   )
//                 : ListView.builder(
//                     physics: BouncingScrollPhysics(),
//                     itemCount: _printController.devices.length,
//                     itemBuilder: (context, i) {
//                       var printer = _printController.devices[i];
//                       return ListTile(
//                           leading: Icon(Icons.print),
//                           title: Text(printer.name),
//                           subtitle: Text(printer.address),
//                           onTap: () {
//                             _data['isReceipt'] == false || _data['isReceipt'] == null
//                                 ? Get.dialog(
//                                     AlertDialog(
//                                       title: Text('Print untuk pengguna baru?'),
//                                       content: Text(
//                                           'Adakah anda ingin memberitahu pengguna untuk fungsi e-waranti?'),
//                                       actions: [
//                                         TextButton(
//                                           onPressed: () {
//                                             _printController.startPrintJobsheet(
//                                                 printer, false, false);
//                                             Get.back();
//                                           },
//                                           child: Text('Tidak'),
//                                         ),
//                                         TextButton(
//                                           onPressed: () {
//                                             _printController.startPrintJobsheet(
//                                                 printer, true, false);
//                                             Get.back();
//                                           },
//                                           child: Text('Ya'),
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 : Get.dialog(
//                                     AlertDialog(
//                                       title: Text('Hasilkan QR Kod?'),
//                                       content: Text(
//                                           'Adakah anda ingin memberitahu pengguna untuk fungsi e-waranti?'),
//                                       actions: [
//                                         TextButton(
//                                           onPressed: () {
//                                             _printController.startPrintJobsheet(
//                                                 printer, false, true);
//                                             Get.back();
//                                           },
//                                           child: Text(
//                                             'Tidak',
//                                             style: TextStyle(
//                                               color: Colors.amber[900],
//                                             ),
//                                           ),
//                                         ),
//                                         TextButton(
//                                           onPressed: () {
//                                             _printController.startPrintJobsheet(
//                                                 printer, true, true);
//                                             Get.back();
//                                           },
//                                           child: Text('Hasilkan'),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                           });
//                     },
//                   ),
//           );
//         },
//       ),
//     );
//   }
// }
