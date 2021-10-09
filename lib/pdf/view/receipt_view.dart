import 'package:admin_panel/pdf/controller/receipt_pdf_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:get/get.dart';

class ReceiptPDF extends StatelessWidget {
  final _controller = Get.put(ReceiptPDFController());
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _controller.writeReceiptPDF(),
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
              path: _controller.fullPath);
        });
  }
}
