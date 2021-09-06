import 'package:admin_panel/pdf/controller/pdf_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:get/get.dart';

class PdfViewer extends StatelessWidget {
  final _pdfController = Get.put(PdfController());
  final _data = Get.parameters;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _pdfController.writeJobsheetPdf(
          //TODO: Buat dynamic cawangan!
          cawangan: 'Kajang',
          kerosakkan: Get.parameters["kerosakkan"],
          model: _data['model'],
          mysid: _data['mysid'],
          namaCust: _data['nama'],
          noTel: _data['noTel'],
          price: _data['price'],
          remarks: _data['remarks'],
          //TODO: Buat dynamic technician!
          technician: 'Akid Fikri Azhar',
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
                      'Akid Fikri Azhar', //TODO: buat dynamic techician
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
