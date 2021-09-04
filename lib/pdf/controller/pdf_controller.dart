import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfController extends GetxController {
  final pdf = pw.Document();

  String fullPath = '';

  Future<void> writeJobsheetPdf() async {
    var assetImage = pw.MemoryImage(
      (await rootBundle.load('assets/images/splash_dark.png'))
          .buffer
          .asUint8List(),
    );
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a5,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        margin: pw.EdgeInsets.all(15),
        build: (pw.Context context) {
          return <pw.Widget>[
            _jobheetHeader(assetImage),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _jobsheetSubheader('Tarikh: ', '1/1/2022'),
                    _jobsheetSubheader('Juruteknik: ', 'Akid Fikri Azhar'),
                    _jobsheetSubheader('Cawangan: ', 'Kajang'),
                  ],
                ),
                pw.BarcodeWidget(
                  data: 'https://af-fix-database.web.app/mysid?id=125752',
                  width: 60,
                  height: 60,
                  barcode: pw.Barcode.qrCode(),
                  drawText: false,
                ),
              ],
            ),
            pw.SizedBox(height: 10),
            _jobsheetContent('Nama Pelanggan: ', 'Aqlan Fathullah'),
            _jobsheetContent('No Telefon: ', '0156987456'),
            _jobsheetContent('Model: ', 'iPhone 11 Pro Max'),
            _jobsheetContent('Kerosakkan: ', 'LCD'),
            _jobsheetContent('Anggaran Harga: ', 'RM820'),
            _jobsheetContent('Remarks: ', '*Screen crack, Sparepart OLED'),
            pw.SizedBox(height: 10),
            pw.Divider(thickness: 0.5),
            pw.Text(
              'Terma Dan Syarat:',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
                '1. Kami berhak untuk mengubah mana-mana terma dan syarat.'),
            pw.Text(
                '2. Kami tidak bertanggungjawab sekiranya ada kehilangan data.'),
            pw.Text(
                '3. Pastikan kad memori, dan sim kad anda tidak dimasukkan daripada peranti anda semasa menghantar peranti anda kepada kami.'),
            pw.SizedBox(height: 10),
            pw.Text(
              'Untuk maklumat lebih lanjut tentang terma ,syarat dan juga privasi. Sila layari website kami - https://af-fix-database.web.app/terms',
              style: pw.TextStyle(
                color: PdfColors.grey,
              ),
            ),
          ];
        },
      ),
    );
    String titleName = 'we';
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/$titleName-resit.pdf';
    fullPath = path;
    final File file = File(path);
    await file.writeAsBytes(await pdf.save());
  }

  pw.Header _jobheetHeader(pw.MemoryImage assetImage) {
    return pw.Header(
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: <pw.Widget>[
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Jobsheet',
                style: pw.TextStyle(
                  fontSize: 40,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.lightBlue,
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                'MyStatus Identification: 2342456',
              ),
              pw.SizedBox(height: 2),
            ],
          ),
          pw.Image(assetImage, height: 50),
        ],
      ),
    );
  }

  pw.RichText _jobsheetSubheader(String title, String content) {
    return pw.RichText(
      text: pw.TextSpan(
        text: title,
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

  pw.Column _jobsheetContent(String title, String content) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
              color: PdfColors.lightBlue, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 5),
        pw.Text(content),
        pw.SizedBox(height: 10),
      ],
    );
  }
}
