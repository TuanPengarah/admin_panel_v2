import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowDetailParts {
  static String getSupplierCode(String code) {
    switch (code) {
      case 'MG':
        return 'Mobile Gadget Resources';
        break;
      case 'G':
        return 'Golden';
        break;
      case 'OR':
        return 'Orange Phonetech';
        break;
      case 'GM':
        return 'GM Communication';
        break;
      case 'RnJ':
        return 'RnJ Spareparts';
        break;
      default:
        return code;
    }
  }

  static void details({
    @required String title,
    @required String id,
    @required String tarikh,
    @required String harga,
    @required String supplier,
    @required String jenisSparepart,
    @required String maklumatSparepart,
    @required String kualiti,
  }) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text.rich(
              TextSpan(
                text: 'Tarikh Kemaskini: ',
                style: TextStyle(fontSize: 14),
                children: [
                  TextSpan(
                    text: tarikh,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Text.rich(
              TextSpan(
                text: 'Supplier: ',
                style: TextStyle(fontSize: 14),
                children: [
                  TextSpan(
                    text: getSupplierCode(supplier),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Text.rich(
              TextSpan(
                text: 'Maklumat Spareparts: ',
                style: TextStyle(fontSize: 14),
                children: [
                  TextSpan(
                    text: maklumatSparepart,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Text.rich(
              TextSpan(
                text: 'Harga Supplier: ',
                style: TextStyle(fontSize: 14),
                children: [
                  TextSpan(
                    text: 'RM$harga',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Text.rich(
              TextSpan(
                text: 'Parts ID: ',
                style: TextStyle(fontSize: 14),
                children: [
                  TextSpan(
                    text: id,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Buang',
              style: TextStyle(
                color: Colors.amber[900],
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text('Kemaskini'),
          ),
        ],
      ),
    );
  }
}
