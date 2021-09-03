import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfController extends GetxController {
  final pdf = pw.Document();
  String fullPath = '';

  // @override
  // void onInit() {
  //   writeJobsheetPdf();
  //   super.onInit();
  // }

  Future<void> writeJobsheetPdf() async {
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a5,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        margin: pw.EdgeInsets.all(15),
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Header(
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
                  pw.PdfLogo(),
                  // pw.Image(assetImage, height: 50),
                ],
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
}
