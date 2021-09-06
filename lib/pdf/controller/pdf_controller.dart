import 'dart:io';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class PdfController extends GetxController {
  final pdf = pw.Document();

  String fullPath = '';
  String tarikh = DateFormat('dd/mm/yyyy').format(DateTime.now());

  void sendEmailPDF(String email, String technician, userName) async {
    String currentEmail = email;
    if (email.isEmpty) {
      currentEmail = userName.split(" ").join("").toLowerCase() + '@email.com';
      print(currentEmail);
    }
    // dan boleh semak status baiki peranti di website kami https://af-fix.com/mysid dan masukkan nombor MyStatus Identification (MySID) yang tertulis pada resit Jobsheet ini atau lebih mudah boleh terus mengimbas QR Code yang juga terdapat pada resit ini',
    final MailOptions mailOptions = MailOptions(
      body:
          'Assalumalaikum dan salam sejahtera $userName!<br><br>Disini kami lampirkan resit Jobsheet untuk peranti awak. $userName boleh simpan resit ini untuk tujuan rujukan😁<br><br>------------------<br>Pssst! Untuk pengetahuan, $userName boleh semak status baiki peranti dengan mengimbas kod QR atau boleh terus melayari aplikasi web kami https://af-fix.com/mysid dan masukkan nombor MyStatus Identification (MySID) yang terdapat pada resit Jobsheet awak🤫<br><br>--AINA',
      subject: '$technician dari Juruteknik Af-Fix🧑‍🔧',
      recipients: ['$currentEmail'],
      isHTML: true,
      attachments: [
        '$fullPath',
      ],
    );
    await FlutterMailer.send(mailOptions);
    Haptic.feedbackSuccess();
  }

  void sharePDF() {
    Share.shareFiles(['$fullPath'], text: 'Maklumat PDF');
  }

  Future<void> writeJobsheetPdf({
    @required String mysid,
    @required String namaCust,
    @required String noTel,
    @required String model,
    @required String kerosakkan,
    @required String price,
    @required String remarks,
    @required String technician,
    @required String cawangan,
  }) async {
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
            _jobheetHeader(assetImage, mysid),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _jobsheetSubheader('Tarikh: ', '$tarikh'),
                    _jobsheetSubheader('Juruteknik: ', '$technician'),
                    _jobsheetSubheader('Cawangan: ', '$cawangan'),
                  ],
                ),
                pw.BarcodeWidget(
                  data: 'https://af-fix-database.web.app/mysid?id=$mysid',
                  width: 60,
                  height: 60,
                  barcode: pw.Barcode.qrCode(),
                  drawText: false,
                ),
              ],
            ),
            pw.SizedBox(height: 10),
            _jobsheetContent('Nama Pelanggan: ', '$namaCust'),
            _jobsheetContent('No Telefon: ', '$noTel'),
            _jobsheetContent('Model: ', '$model'),
            _jobsheetContent('Kerosakkan: ', '$kerosakkan'),
            _jobsheetContent('Anggaran Harga: ', 'RM$price'),
            _jobsheetContent('Remarks: ', '*$remarks'),
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
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                color: PdfColors.grey,
                fontSize: 10,
              ),
            ),
          ];
        },
      ),
    );
    String titleName = 'Jobsheet';
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/$titleName.pdf';
    fullPath = path;
    final File file = File(path);
    await file.writeAsBytes(await pdf.save());
  }

  pw.Header _jobheetHeader(pw.MemoryImage assetImage, String mysid) {
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
                'MyStatus Identification: $mysid',
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
