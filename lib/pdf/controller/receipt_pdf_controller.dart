import 'dart:io';

import 'package:admin_panel/POS/controller/payment_controller.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class ReceiptPDFController extends GetxController {
  final _paymentController = Get.find<PaymentController>();
  final pdf = pw.Document();
  String fullPath = '';

  void sendEmailPDF(String email, String technician, userName) async {
    String currentEmail = email;
    if (email.isEmpty) {
      currentEmail = userName.split(" ").join("").toLowerCase() + '@email.com';
      print(currentEmail);
    }
    final MailOptions mailOptions = MailOptions(
      body:
          'Assalumalaikum dan salam sejahtera $userName!<br><br>Ini adalah resit pembayaran untuk peranti awak. $userName boleh simpan resit ini untuk tujuan rujukan😁<br><br>------------------<br>Pssst! Untuk pengetahuan, $userName boleh semak status baiki peranti dan semak status waranti dengan melayari aplikasi web kami https://af-fix.com/e-warranty dan masukkan email awak dan password: 123456🤫<br><br>--AINA',
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
    Share.shareFiles(['$fullPath'], text: 'Resit Pembelian');
  }

  Future<void> writeReceiptPDF() async {
    // var assetImage = pw.MemoryImage(
    //   (await rootBundle.load('assets/images/splash_dark.png')).buffer.asUint8List(),
    // );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a5,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        margin: pw.EdgeInsets.all(15),
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Text('Hello World'),
            pw.Table.fromTextArray(
              headers: ['Butir', 'Jumlah (RM)'],
              data: _paymentController.bills
                  .map((e) => [
                        e['title'],
                        e['harga'].toDouble(),
                      ])
                  .toList(),
            ),
            pw.Container(
                margin: const pw.EdgeInsets.only(top: 10, right: 30),
                alignment: pw.Alignment.centerRight,
                child: pw.Text('Jumlah: RM${_paymentController.totalBillsPrice}'))
          ];
        },
      ),
    );
    String titleName = 'Receipt';
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/$titleName.pdf';
    fullPath = path;
    final File file = File(path);
    await file.writeAsBytes(await pdf.save());
    Haptic.feedbackSuccess();
    print(fullPath);
  }
}
