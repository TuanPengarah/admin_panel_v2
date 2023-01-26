import 'dart:io';
import 'package:admin_panel/cash_flow/model/cashflow_model.dart';
import 'package:admin_panel/graph/graph_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../../config/haptic_feedback.dart';

class CashFlowStatementController extends GetxController {
  final _graphController = Get.find<GraphController>();
  final pdf = pw.Document();

  String fullPath = '';

  void sharePDF(int bulan) {
    Haptic.feedbackClick();
    Share.shareXFiles([XFile(fullPath)],
        text:
            'Maklumat Penyata Cash Flow Bulan ${_graphController.checkMonthsMalay(bulan)} | ${_graphController.year}');
  }

  Future<void> writeCashFlowStatement(int bulan,
      {double untungBersih, double untungKasar, double modal}) async {
    List<CashFlowModel> cashFlow = [];
    double jumlahBukanSparepartsOut = 0.0;
    double jumlahBukanSparepartsIn = 0.0;
    double jumlahSparepartsOut = 0.0;
    double jumlahSparepartsIn = 0.0;
    double jumlahJualPhoneOut = 0.0;
    double jumlahJualPhoneIn = 0.0;
    String year = DateFormat('yyyy').format(DateTime.now()).toString();
    var assetImage = pw.MemoryImage(
      (await rootBundle.load('assets/images/splash_dark.png'))
          .buffer
          .asUint8List(),
    );

    var snapshot = await FirebaseFirestore.instance
        .collection('Sales')
        .doc(year)
        .collection('cashFlow')
        .get();

    snapshot.docs.forEach((doc) {
      DateTime dt = (doc['timeStamp'] as Timestamp).toDate();

      if (dt.month == bulan + 1) {
        cashFlow.add(CashFlowModel.fromJson(doc));
      }
    });
    cashFlow..sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
    cashFlow.forEach((e) {
      if (e.isSpareparts == true &&
          e.isModal == true &&
          e.isJualPhone == true) {
        jumlahBukanSparepartsOut += e.jumlah;
      }
      if (e.isSpareparts == true &&
          e.isModal == false &&
          e.isJualPhone == true) {
        jumlahBukanSparepartsIn += e.jumlah;
      }
      if (e.isSpareparts == false && e.isModal == true) {
        jumlahSparepartsOut += e.jumlah;
      }
      if (e.isSpareparts == false && e.isModal == false) {
        jumlahSparepartsIn += e.jumlah;
      }
      if (e.isJualPhone == false &&
          e.isSpareparts == true &&
          e.isModal == false) {
        jumlahJualPhoneIn += e.jumlah;
      }
      if (e.isJualPhone == false &&
          e.isSpareparts == true &&
          e.isModal == true) {
        jumlahJualPhoneOut += e.jumlah;
      }
    });

    pdf.addPage(
      pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(15),
          footer: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Divider(color: PdfColors.grey),
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text('${context.pageNumber}/${context.pagesCount}'),
                ),
              ],
            );
          },
          build: (pw.Context context) {
            return <pw.Widget>[
              _statementHeader(assetImage, bulan),
              _statementSubheader(
                  'Jumlah keseluruhan', 'RM ${untungKasar.toStringAsFixed(2)}'),
              _statementSubheader(
                  'Jumlah Modal', 'RM ${modal.toStringAsFixed(2)}'),
              _statementSubheader(
                  'Untung Bersih', 'RM ${untungBersih.toStringAsFixed(2)}'),
              pw.SizedBox(height: 30),
              pw.Text('Cash Flow Keseluruhan: -'),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ['Tarikh', 'Butir', 'Harga'],
                border: null,
                cellHeight: 20,
                headerAlignment: pw.Alignment.centerLeft,
                data: cashFlow
                    .map((e) => [
                          DateFormat('dd/MM/yyyy')
                              .format(e.timeStamp.toDate())
                              .toString(),
                          e.remark,
                          e.isModal == true
                              ? ' - RM ${e.jumlah}'
                              : '+ RM ${e.jumlah}',
                        ])
                    .toList(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerDecoration: pw.BoxDecoration(
                  color: PdfColors.blue300,
                ),
              ),
            ];
          }),
    );

    pdf.addPage(
      pw.MultiPage(
        footer: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Divider(color: PdfColors.grey),
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Text('${context.pageNumber}/${context.pagesCount}'),
              ),
            ],
          );
        },
        build: (context) {
          return <pw.Widget>[
            pw.SizedBox(height: 15),
            pw.Divider(color: PdfColors.grey),
            pw.SizedBox(height: 15),
            pw.Text('Cash Flow mengikut pecahan Spareparts sahaja:- '),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: ['Tarikh', 'Butir', 'Harga'],
              border: null,
              cellHeight: 20,
              headerAlignment: pw.Alignment.centerLeft,
              data: cashFlow
                  .where(
                      (e) => e.isSpareparts == false && e.isJualPhone == true)
                  .map((e) => [
                        DateFormat('dd/MM/yyyy')
                            .format(e.timeStamp.toDate())
                            .toString(),
                        e.remark,
                        e.isModal == true
                            ? ' - RM ${e.jumlah}'
                            : '+ RM ${e.jumlah}',
                      ])
                  .toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: pw.BoxDecoration(
                color: PdfColors.blue300,
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Jumlah Duit Keluar: $jumlahSparepartsOut',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              'Jumlah Duit Masuk: $jumlahSparepartsIn',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              'Untung bersih untuk sparepart: ${jumlahSparepartsIn - jumlahSparepartsOut}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ];
        },
      ),
    );
    pdf.addPage(
      pw.MultiPage(
        footer: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Divider(color: PdfColors.grey),
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Text('${context.pageNumber}/${context.pagesCount}'),
              ),
            ],
          );
        },
        build: (context) {
          return <pw.Widget>[
            pw.SizedBox(height: 15),
            pw.Divider(color: PdfColors.grey),
            pw.SizedBox(height: 15),
            pw.Text('Cash Flow mengikut BUKAN Spareparts:- '),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: ['Tarikh', 'Butir', 'Harga'],
              border: null,
              cellHeight: 20,
              headerAlignment: pw.Alignment.centerLeft,
              data: cashFlow
                  .where((e) => e.isSpareparts == true && e.isJualPhone == true)
                  .map((e) => [
                        DateFormat('dd/MM/yyyy')
                            .format(e.timeStamp.toDate())
                            .toString(),
                        e.remark,
                        e.isModal == true
                            ? ' - RM ${e.jumlah}'
                            : '+ RM ${e.jumlah}',
                      ])
                  .toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: pw.BoxDecoration(
                color: PdfColors.blue300,
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Jumlah Duit Keluar: $jumlahBukanSparepartsOut',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              'Jumlah Duit Masuk: $jumlahBukanSparepartsIn',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ];
        },
      ),
    );
    pdf.addPage(
      pw.MultiPage(
        footer: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Divider(color: PdfColors.grey),
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Text('${context.pageNumber}/${context.pagesCount}'),
              ),
            ],
          );
        },
        build: (context) {
          return <pw.Widget>[
            pw.SizedBox(height: 15),
            pw.Divider(color: PdfColors.grey),
            pw.SizedBox(height: 15),
            pw.Text('Cash Flow mengikut Jual Phone:- '),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: ['Tarikh', 'Butir', 'Harga'],
              border: null,
              cellHeight: 20,
              headerAlignment: pw.Alignment.centerLeft,
              data: cashFlow
                  .where(
                      (e) => e.isJualPhone == false && e.isSpareparts == true)
                  .map((e) => [
                        DateFormat('dd/MM/yyyy')
                            .format(e.timeStamp.toDate())
                            .toString(),
                        e.remark,
                        e.isModal == true
                            ? ' - RM ${e.jumlah}'
                            : '+ RM ${e.jumlah}',
                      ])
                  .toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: pw.BoxDecoration(
                color: PdfColors.blue300,
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Jumlah Duit Keluar: $jumlahJualPhoneOut',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              'Jumlah Duit Masuk: $jumlahJualPhoneIn',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              'Untung bersih untuk jual phone: ${jumlahJualPhoneIn - jumlahJualPhoneOut}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ];
        },
      ),
    );

    String titleName =
        'Cashflow Statement ${_graphController.checkMonthsMalay(bulan)} | $year';
    if (!GetPlatform.isWeb) {
      final String dir = (await getApplicationDocumentsDirectory()).path;
      final String path = '$dir/$titleName.pdf';
      fullPath = path;
      final File file = File(path);
      await file.writeAsBytes(await pdf.save());
    }
    Haptic.feedbackSuccess();
  }

  pw.RichText _statementSubheader(String title, String content) {
    return pw.RichText(
      text: pw.TextSpan(
        text: '$title : ',
        children: [
          pw.TextSpan(
            text: content,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  pw.Header _statementHeader(pw.MemoryImage assetImage, int bulan) {
    return pw.Header(
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: <pw.Widget>[
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Cash Flow Statement',
                style: pw.TextStyle(
                  fontSize: 35,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.lightBlue,
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                'Rekod keseluruhan untuk bulan ${_graphController.checkMonthsMalay(bulan)} | ${_graphController.year.toString()}',
              ),
              pw.SizedBox(height: 10),
            ],
          ),
          pw.Image(assetImage, height: 55),
        ],
      ),
    );
  }
}
