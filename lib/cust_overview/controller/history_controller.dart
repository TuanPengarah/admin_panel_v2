import 'package:admin_panel/POS/controller/payment_controller.dart';
import 'package:admin_panel/calculator/controller/price_calc_controller.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RepairHistoryController extends GetxController {
  final _data = Get.arguments;
  List items = [];
  var totalPrice = ''.obs;
  @override
  void onInit() {
    getFromFirestore();
    super.onInit();
  }

  void showShareJobsheet(Map<String, dynamic> data) {
    Get.bottomSheet(
      Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.print),
              title: Text('Print Jobsheet'),
              subtitle: Text('Print maklumat Jobsheet ini!'),
              onTap: () {
                Get.back();
                Get.toNamed(MyRoutes.printView, arguments: data);
              },
            ),
            ListTile(
              leading: Icon(Icons.picture_as_pdf),
              title: Text('Hasilkan Jobsheet PDF'),
              subtitle: Text('Hasilkan maklumat Jobsheet berformat PDF!'),
              onTap: () {
                Get.back();
                Get.toNamed(MyRoutes.pdfJobsheeetViewer, arguments: data);
              },
            ),
            data['status'] == 'Selesai'
                ? ListTile(
                    leading: Icon(Icons.more_horiz),
                    title: Text('Lagi'),
                    subtitle: Text('Pilihan untuk menghasilkan Resit Waranti!'),
                    onTap: () {
                      Get.back();
                      dialogReceipt(data);
                    },
                  )
                : Container(),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void dialogReceipt(Map<String, dynamic> data) {
    Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.print),
              title: Text('Print Resit Waranti'),
              subtitle: Text('Print maklumat resit waranti untuk model ini!'),
              onTap: () {
                Get.toNamed(MyRoutes.printView, arguments: {
                  'isReceipt': true,
                  'technician': data['technician'],
                  'nama': data['nama'],
                  'noTel': data['noTel'],
                });
              },
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.picture_as_pdf),
              title: Text('Hasilkan Resit Waranti PDF'),
              subtitle: Text('Hasilkan maklumat resit waranti berformat PDF!'),
              onTap: () {
                Get.put(PriceCalculatorController());

                final payment = Get.put(PaymentController());

                final value = {
                  'title': data['kerosakkan'] + ' ' + data['model'],
                  'waranti': '',
                  'harga': data['price'],
                  'technician': data['technician'],
                };
                payment.bills.add(value);
                payment.totalBillsPrice.value = int.parse(data['price']);
                payment.customerName = data['nama'];
                payment.phoneNumber = '';
                print(payment.bills[0]);
                Get.back();
                Get.toNamed(MyRoutes.pdfReceiptViewer,
                    arguments: {'isBills': false});
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getFromFirestore() async {
    double sum = 0.0;
    await FirebaseFirestore.instance
        .collection('customer')
        .doc(_data[0])
        .collection('repair history')
        .orderBy('timeStamp', descending: true)
        .get()
        .then((snapshot) => items = snapshot.docs);

    items.forEach((item) {
      if (item['Status'] == 'Selesai') {
        sum += item['Harga'];
      }
    });
    totalPrice.value = sum.toString();
  }
}
