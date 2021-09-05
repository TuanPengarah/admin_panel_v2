import 'package:admin_panel/pdf/controller/pdf_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:get/get.dart';

class PdfViewer extends StatelessWidget {
  final _pdfController = Get.put(PdfController());
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _pdfController.writeJobsheetPdf(),
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
                    onPressed: () => _pdfController.sendEmailPDF(),
                    icon: Icon(Icons.email),
                  ),
                  IconButton(
                    onPressed: () => _pdfController.sharePDF(),
                    icon: Icon(Icons.share),
                  ),
                ],
              ),
              path: _pdfController.fullPath);
        });
  }
}
