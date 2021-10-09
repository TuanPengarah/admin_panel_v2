import 'package:admin_panel/auth/controller/firebaseAuth_controller.dart';
import 'package:admin_panel/pdf/controller/pdf_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PdfViewer extends StatelessWidget {
  final _pdfController = Get.put(PdfController());
  final _authController = Get.find<AuthController>();
  final _data = Get.arguments;
  @override
  Widget build(BuildContext context) {
    DateTime dt = (_data['timeStamp'] as Timestamp).toDate();

    return FutureBuilder(
        future: _pdfController.writeJobsheetPdf(
          cawangan: _authController.cawangan.toString(),
          kerosakkan: Get.arguments["kerosakkan"],
          model: _data['model'],
          mysid: _data['mysid'],
          namaCust: _data['nama'],
          noTel: _data['noTel'],
          price: _data['price'],
          remarks: _data['remarks'],
          technician: _data['technician'],
          tarikh: DateFormat('dd-MM-yyyy | hh:mm a').format(dt).toString(),
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return PDFViewerScaffold(
              appBar: AppBar(
                title: Text('Jobsheet details'),
                actions: [
                  IconButton(
                    onPressed: () => _pdfController.sendEmailPDF(
                      _data['email'],
                      _authController.userName.toString(),
                      _data['nama'],
                    ),
                    icon: Icon(Icons.email),
                  ),
                  IconButton(
                    onPressed: () {
                      print(_data['kerosakkan']);
                      _pdfController.sharePDF();
                    },
                    icon: Icon(Icons.share),
                  ),
                ],
              ),
              path: _pdfController.fullPath);
        });
  }
}
