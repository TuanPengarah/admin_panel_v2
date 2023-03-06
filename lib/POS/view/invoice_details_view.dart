import 'package:admin_panel/POS/model/invoice_model.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:admin_panel/home/controller/customer_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quds_popup_menu/quds_popup_menu.dart';

import '../../calculator/controller/price_calc_controller.dart';
import '../../config/routes.dart';
import '../controller/payment_controller.dart';

class ViewInvoiceDetail extends StatelessWidget {
  final _customerController = Get.find<CustomerController>();
  final _id = Get.parameters;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maklumat Invois'),
        actions: [
          QudsPopupButton(
            child: Icon(Icons.more_vert),
            items: [
              QudsPopupMenuItem(
                title: Text('Maklumat Pelanggan'),
                leading: Icon(Icons.person),
                onPressed: () {
                  var customer = _customerController.customerList.where((cust) {
                    return cust['UID'] == _id['uid'];
                  }).toList()[0];
                  Get.toNamed(MyRoutes.overview, arguments: {
                    'UID': customer['UID'],
                    'Nama': customer['Nama'],
                    'photoURL': customer['photoURL'],
                    'No Phone': customer['No Phone'],
                    'Email': customer['Email'],
                    'Points': customer['Points'],
                    'timeStamp': customer['timeStamp']
                  });
                },
              ),
              QudsPopupMenuItem(
                title: Text(
                  'Buang',
                  style: TextStyle(color: Colors.red),
                ),
                leading: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      icon: Icon(Icons.delete),
                      title: Text('Buang Invois'),
                      content:
                          Text('Adakah anda pasti untuk membuang invois ini?'),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            Get.closeAllSnackbars();
                            Get.back();
                            Get.back();
                            await Future.delayed(Duration(seconds: 1));
                            await FirebaseDatabase.instance
                                .ref('Invoices/${_id['id']}')
                                .remove();
                            ShowSnackbar.success('Operasi selesai!',
                                'Invois telah dipadam', false);
                          },
                          child: Text(
                            'Pasti',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Haptic.feedbackSuccess();
                            Get.back();
                          },
                          child: Text('Batal'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder(
          stream:
              FirebaseDatabase.instance.ref('Invoices/${_id['id']}').onValue,
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            if (snapshot.hasData) {
              var data = snapshot.data.snapshot.value as Map<dynamic, dynamic>;
              var invoice = InvoiceDetailsModel.fromDatabase(data);
              double totalPrice = 0;

              invoice.invoiceList.forEach(
                (total) {
                  totalPrice += double.parse(total['price'].toString());
                },
              );

              return Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: ListView.builder(
                      itemCount: invoice.invoiceList.length,
                      itemBuilder: (BuildContext context, int i) {
                        var list = invoice.invoiceList[i];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(list['title'].toString()),
                            trailing: Text('RM ${list['price']}'),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(9),
                      height: 90,
                      color: !Get.isDarkMode
                          ? Colors.grey.shade300
                          : Colors.grey[850],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(children: [
                            Expanded(
                              flex: 8,
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.put(PriceCalculatorController());

                                  final payment = Get.put(PaymentController());
                                  var customer = _customerController
                                      .customerList
                                      .where((cust) {
                                    return cust['UID'] == _id['uid'];
                                  }).toList()[0];

                                  Map<String, dynamic> value = {};
                                  payment.bills = [];

                                  for (var inv in invoice.invoiceList) {
                                    value = {
                                      'title': inv['title'],
                                      'waranti': inv['warranty'],
                                      'harga': inv['price'],
                                      'technician': invoice.technician,
                                      'noTel': customer['No Phone'],
                                      'nama': customer['Nama'],
                                    };
                                    payment.bills.add(value);
                                  }

                                  payment.totalBillsPrice.value = totalPrice;
                                  payment.customerName = customer['Nama'];
                                  payment.phoneNumber = customer['No Phone'];
                                  print(payment.bills);
                                  Get.toNamed(MyRoutes.pdfReceiptViewer,
                                      arguments: {
                                        'isBills': true,
                                        'tarikh': DateFormat('dd-MM-yyyy')
                                            .format(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    int.parse(_id['id'])))
                                      });
                                },
                                child: const Text('Hasilkan Resit'),
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Jumlah',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    'RM $totalPrice',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                          const SizedBox(height: 5),
                          Text(
                            invoice.ispay == true
                                ? '- Invois Ini Telah Dibayar -'
                                : '- Invois Ini Belum Dibayar Lagi',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return Center(
              child: const Text('An error has accured'),
            );
          }),
    );
  }
}
