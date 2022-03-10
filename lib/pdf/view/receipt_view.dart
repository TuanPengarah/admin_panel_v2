import 'dart:io';

import 'package:admin_panel/pdf/controller/receipt_pdf_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ReceiptPDF extends StatelessWidget {
  final _controller = Get.put(ReceiptPDFController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maklumat Resit'),
        actions: [
          IconButton(
            onPressed: () {
              _controller.sharePDF();
            },
            icon: Icon(Icons.share),
          ),
        ],
      ),
      body: FutureBuilder(
          future: _controller.writeReceiptPDF(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return SfPdfViewer.file(File(_controller.fullPath));
            // return PDFViewerScaffold(

            //     path: _controller.fullPath);
          }),
    );
  }
}
