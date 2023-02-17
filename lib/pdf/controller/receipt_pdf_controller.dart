import 'dart:io';
import 'package:admin_panel/POS/controller/payment_controller.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class ReceiptPDFController extends GetxController {
  final _paymentController = Get.find<PaymentController>();
  final pdf = pw.Document();
  String fullPath = '';
  final _data = Get.arguments;

  String _tarikh() {
    final tarikhDart = DateTime.now();
    return DateFormat('dd/MM/yyyy').format(tarikhDart).toString();
  }

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
    Share.shareXFiles([XFile(fullPath)], text: 'Invois');
  }

  Future<void> writeReceiptPDF() async {
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
          header: (pw.Context context) {
            return pw.Header(
              decoration: pw.BoxDecoration(),
              child: pw.Column(
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'INVOIS',
                            style: pw.TextStyle(
                              color: PdfColors.blue,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          pw.Text(
                            'Sila simpan resit ini untuk tujuan waranti (jika ada)',
                            style: pw.TextStyle(
                              color: PdfColors.grey,
                            ),
                          ),
                        ],
                      ),
                      pw.Image(assetImage, height: 50),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                ],
              ),
            );
          },
          build: (pw.Context context) {
            return <pw.Widget>[
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Af-Fix Smartphone Repair',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text('Lot Pt.87977, Lorong 10,'),
                            pw.Text('Jln. Paya Putra,'),
                            pw.Text('Kg. Sg. Ramal Baru,'),
                            pw.Text('43000 Kajang,'),
                            pw.Text('Selangor Darul Ehsan'),
                          ],
                        ),
                        pw.BarcodeWidget(
                          data: 'https://af-fix.com/e-warranty',
                          width: 60,
                          height: 60,
                          barcode: pw.Barcode.qrCode(),
                          drawText: false,
                        ),
                      ]),
                  pw.SizedBox(height: 40),
                  pw.Text('Tarikh: ${_data['tarikh']}'),
                  _paymentController.customerName != '' &&
                          _paymentController.phoneNumber != ''
                      ? pw.Text('Nama: ${_paymentController.customerName}')
                      : pw.Container(),
                  _paymentController.customerName != '' &&
                          _paymentController.phoneNumber != ''
                      ? pw.Text('No Telefon: ${_paymentController.phoneNumber}')
                      : pw.Container(),
                  pw.Text(
                      'Technician/Staff: ${_paymentController.bills[0]['technician']}'),
                  pw.SizedBox(height: 15),
                  _data['isBills'] == true
                      ? pw.Table.fromTextArray(
                          headers: ['Butir', 'Waranti', 'Jumlah (RM)'],
                          data: _paymentController.bills
                              .map((e) => [
                                    e['title'],
                                    e['waranti'],
                                    e['harga'].toDouble(),
                                  ])
                              .toList(),
                          border: null,
                          headerStyle:
                              pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          headerDecoration: pw.BoxDecoration(
                            color: PdfColors.blue300,
                          ),
                          cellHeight: 30,
                          cellAlignments: {
                            0: pw.Alignment.centerLeft,
                            1: pw.Alignment.centerRight,
                            2: pw.Alignment.centerRight,
                          },
                        )
                      : pw.Table(
                          children: [
                            pw.TableRow(
                              decoration: pw.BoxDecoration(
                                color: PdfColors.blue,
                                border: pw.Border.all(
                                  color: PdfColors.blue,
                                ),
                              ),
                              verticalAlignment:
                                  pw.TableCellVerticalAlignment.middle,
                              children: [
                                pw.Padding(
                                  padding: pw.EdgeInsets.all(10),
                                  child: pw.Text(
                                    'Butir',
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ),
                                pw.Padding(
                                  padding: pw.EdgeInsets.all(10),
                                  child: pw.Text(
                                    'Waranti',
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ),
                                pw.Padding(
                                  padding: pw.EdgeInsets.all(10),
                                  child: pw.Text(
                                    'Harga',
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            pw.TableRow(
                              verticalAlignment:
                                  pw.TableCellVerticalAlignment.bottom,
                              children: [
                                pw.Padding(
                                  padding: pw.EdgeInsets.all(10),
                                  child: pw.Text(
                                    '${_paymentController.bills[0]['title']}',
                                  ),
                                ),
                                pw.Padding(
                                  padding: pw.EdgeInsets.all(10),
                                  child: pw.Text(
                                      '${_paymentController.bills[0]['waranti']}'),
                                ),
                                pw.Padding(
                                  padding: pw.EdgeInsets.all(10),
                                  child: pw.Text(
                                    '${_paymentController.bills[0]['harga']}',
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                  pw.Divider(color: PdfColors.blue300),
                  pw.Container(
                    margin: const pw.EdgeInsets.only(top: 5),
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      'Jumlah:  RM${_paymentController.totalBillsPrice}',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ];
          },
          footer: (pw.Context context) {
            return pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Center(
                  child: pw.Text(
                    'Anda juga boleh melihat status waranti di laman portal kami: www.af-fix.com/e-warranty',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      color: PdfColors.grey,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            );
          }),
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
