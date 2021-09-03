import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoneJobsheetController extends GetxController {
  void showShareJobsheet() {
    Get.bottomSheet(
      Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.print),
              title: Text('Print'),
              subtitle: Text('Print maklumat Jobsheet ini!'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.picture_as_pdf),
              title: Text('PDF'),
              subtitle: Text('Hasilkan maklumat Jobsheet berformat PDF!'),
              onTap: () {},
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
