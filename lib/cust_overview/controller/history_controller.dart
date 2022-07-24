import 'package:admin_panel/POS/controller/payment_controller.dart';
import 'package:admin_panel/calculator/controller/price_calc_controller.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

class RepairHistoryController extends GetxController {
  final _data = Get.arguments;
  List items = [];
  var totalPrice = ''.obs;
  @override
  void onInit() {
    getFromFirestore();
    super.onInit();
  }

  String _getWarranty(int minggu) {
    String warranty = '-';

    if (minggu == 1) {
      warranty = '1 Minggu';
    } else if (minggu == 4) {
      warranty = '1 Bulan';
    } else if (minggu == 8) {
      warranty = '2 Bulan';
    } else if (minggu >= 12) {
      warranty = '3 Bulan';
    } else {
      warranty = '-';
    }

    return warranty;
  }

  void showShareJobsheet(Map<String, dynamic> data) {
    var jiffy1 = Jiffy(data['tarikh'], 'dd-MM-yyyy');
    var jiffy2 = Jiffy(data['waranti'], 'dd-MM-yyyy');
    int minggu = jiffy2.diff(jiffy1, Units.WEEK);
    debugPrint('jumlah waranti $minggu');
    Get.bottomSheet(
      Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.receipt),
              title: Text('Maklumat'),
              subtitle: Text('Lihat maklumat untuk model ini'),
              onTap: () {
                var params = <String, String>{'id': data['mysid']};

                var payload = {
                  'Nama': data['nama'],
                  'Model': data['model'],
                  'Kerosakkan': data['kerosakkan'],
                  'Password': data['password'],
                  'Remarks': data['remarks'],
                  'Percent': 1.0,
                  'No Phone': data['noTel'],
                };
                Get.back();
                Get.toNamed(MyRoutes.mysidUpdate,
                    arguments: payload, parameters: params);
              },
            ),
            ListTile(
              leading: Icon(Icons.receipt),
              title: Text('Hasilkan Jobsheet'),
              subtitle: Text('Hasilkan maklumat Jobsheet'),
              onTap: () {
                Get.back();
                Get.toNamed(MyRoutes.pdfJobsheeetViewer, arguments: data);
              },
            ),
            data['status'] == 'Selesai'
                ? ListTile(
                    leading: Icon(Icons.receipt_long),
                    title: Text('Hasilkan Resit'),
                    subtitle: Text('Print maklumat Invois!'),
                    onTap: () {
                      // Get.back();
                      Get.put(PriceCalculatorController());

                      final payment = Get.put(PaymentController());

                      final value = {
                        'title': data['kerosakkan'],
                        'waranti': '${_getWarranty(minggu)}',
                        'harga': data['price'],
                        'technician': data['technician'],
                        'noTel': data['noTel'],
                        'nama': data['nama'],
                      };
                      payment.bills.add(value);
                      payment.totalBillsPrice.value =
                          double.parse(data['price']);
                      payment.customerName = data['nama'];
                      payment.phoneNumber = data['noTel'];
                      print(payment.bills[0]);
                      Get.back();
                      Get.toNamed(MyRoutes.pdfReceiptViewer,
                          arguments: {'isBills': false});
                      // dialogReceipt(data);
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
              onTap: () {},
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
                payment.totalBillsPrice.value = double.parse(data['price']);
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
