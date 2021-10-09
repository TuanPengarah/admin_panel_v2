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
                Get.toNamed(MyRoutes.printJobsheetViewer, arguments: data);
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
            SizedBox(height: 10),
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
