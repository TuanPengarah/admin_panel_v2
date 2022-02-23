import 'package:admin_panel/pdf/controller/cashflow_statement_pdf_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class CashFlowStatementPDF extends GetView<CashFlowStatementController> {
  final _data = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cash Flow Statement'),
        actions: [
          IconButton(
            onPressed: () => controller.sharePDF(_data['bulan']),
            icon: Icon(Icons.share),
          ),
        ],
      ),
      body: FutureBuilder(
          future: controller.writeCashFlowStatement(
            _data['bulan'],
            untungBersih: _data['untungBersih'],
            untungKasar: _data['untungKasar'],
            modal: _data['modal'],
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return PdfViewer.openFile(controller.fullPath);
          }),
    );
  }
}
