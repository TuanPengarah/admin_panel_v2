import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GraphController extends GetxController {
  String year = DateFormat('yyyy').format(DateTime.now()).toString();
  List graphJual = [];
  List graphSupplier = [];
  List<FlSpot> spotJual = [];
  List<FlSpot> spotSupplier = [];
  List<FlSpot> spotUntungBersih = [];

  var jumlahBulanan = 0.0.obs;
  var untungBersih = 0.0.obs;
  var untungKasar = 0.0.obs;
  var jumlahModal = 0.0.obs;
  var percentBulanan = '0'.obs;
  var untungBulananTahunLepas = 0.0.obs;
  List<double> untungBulananTahunLepasSpike = [];
  List<double> untungBersihSpike = [];
  List<double> modalSpike = [];

  Future? getGraph;
  @override
  void onInit() {
    getGraph = getGraphFromFirestore();
    super.onInit();
  }

  double pengiraanPercentBulanan(double bulanIni, double bulanLepas) {
    double jawapan;
    double first;
    //Formula
    //(Bulan ini - Bulan Lepas) x 100 / Bulan Lepas
    first = bulanIni - bulanLepas;
    jawapan = first / bulanLepas * 100;
    // jawapan = bulanIni / bulanLepas * 100;
    return jawapan;
  }

  String showMonthsGraph(int value) {
    switch (value.toInt()) {
      case 0:
        return 'JAN';
      case 1:
        return value > 10 ? '' : 'FEB';
      case 2:
        return 'MAC';
      case 3:
        return value > 10 ? '' : 'APR';
      case 4:
        return 'MEI';
      case 5:
        return value > 10 ? '' : 'JUN';
      case 6:
        return 'JUL';
      case 7:
        return value > 10 ? '' : 'AUG';
      case 8:
        return 'SEP';
      case 9:
        return value > 10 ? '' : 'OCT';
      case 10:
        return 'NOV';
      case 11:
        return value > 10 ? '' : 'DEC';
    }

    return '';
  }

  int getTotalMonth() {
    int totalMonths = 0;
    for (int i = 0; i < DateTime.now().month; i++) {
      totalMonths++;
    }
    return totalMonths;
  }

  List<double> jualanBulanIni() {
    List<double> line = [];
    untungBulananTahunLepasSpike.clear();
    for (int i = 0; i < DateTime.now().month; i++) {
      line.add(double.parse(graphJual[0][checkMonths(i)].toString()));
    }

    untungBulananTahunLepasSpike.add(0);

    for (var element in line) {
      untungBulananTahunLepasSpike.add(element);
      debugPrint(element.toString());
    }

    return line;
  }

  double findY(double untungKasar, double modal) {
    if (untungKasar < modal) {
      return modal;
    } else {
      return untungKasar;
    }
  }

  String checkMonths(int i) {
    switch (i) {
      case 0:
        return 'January';

      case 1:
        return 'February';

      case 2:
        return 'March';

      case 3:
        return 'April';

      case 4:
        return 'May';

      case 5:
        return 'June';

      case 6:
        return 'July';

      case 7:
        return 'August';

      case 8:
        return 'September';

      case 9:
        return 'October';

      case 10:
        return 'November';

      case 11:
        return 'December';

      default:
        return 'December';
    }
  }

  String checkMonthsMalay(int i) {
    switch (i) {
      case 0:
        return 'Januari';

      case 1:
        return 'Februari';

      case 2:
        return 'Mac';

      case 3:
        return 'April';

      case 4:
        return 'Mei';

      case 5:
        return 'Jun';

      case 6:
        return 'Julai';

      case 7:
        return 'Ogos';

      case 8:
        return 'September';

      case 9:
        return 'Oktober';

      case 10:
        return 'November';

      case 11:
        return 'Disember';

      default:
        return 'Disember';
    }
  }

  double getUntungKasar(int bulan) {
    return double.parse(graphJual[0][checkMonths(bulan)].toString());
  }

  double getUntungBersih(int bulan) {
    return getUntungKasar(bulan) - getMonthsHargajual(bulan);
  }

  double getMonthsHargajual(int i) {
    return double.parse(graphSupplier[0][checkMonths(i)].toString());
  }

  double getMonthsUntungBersih(int bulan) {
    return jumlahBulanan.value - getMonthsHargajual(bulan);
  }

  void getGraphLength() async {
    spotJual = [];
    spotSupplier = [];
    spotUntungBersih = [];
    jumlahModal.value = 0;
    untungKasar.value = 0;
    modalSpike.clear();
    untungBersihSpike.clear();

    for (int i = 0; i < DateTime.now().month; i++) {
      spotJual.add(
        FlSpot(i.toDouble(), graphJual[0][checkMonths(i)].toDouble()),
      );
      untungKasar.value += graphJual[0][checkMonths(i)];
    }

    modalSpike.add(0);
    for (int i = 0; i < DateTime.now().month; i++) {
      spotSupplier.add(
        FlSpot(i.toDouble(), graphSupplier[0][checkMonths(i)].toDouble()),
      );
      modalSpike.add(double.parse(graphSupplier[0][checkMonths(i)].toString()));
      jumlahModal.value += graphSupplier[0][checkMonths(i)];
    }
    untungBersihSpike.add(0);
    for (int i = 0; i < DateTime.now().month; i++) {
      spotUntungBersih.add(
        FlSpot(
            i.toDouble(),
            double.parse(graphJual[0][checkMonths(i)].toString()) -
                double.parse(graphSupplier[0][checkMonths(i)].toString())),
      );
      untungBersihSpike.add(
          double.parse(graphJual[0][checkMonths(i)].toString()) -
              double.parse(graphSupplier[0][checkMonths(i)].toString()));
    }

    jumlahBulanan.value = double.parse(
        graphJual[0][checkMonths(DateTime.now().month - 1)].toString());
    untungBersih.value = untungKasar.value - jumlahModal.value;
// DateTime.now().month.toDouble()
    double bulanIni = jumlahBulanan.value;
    double bulanLepas = double.parse(
        graphJual[0][checkMonths(DateTime.now().month - 2)].toString());
    if (bulanLepas <= 0) {
      debugPrint('Happy New Year');
      int tahunLepas = DateTime.now().year - 1;
      List graphTahunLepas = [];
      await FirebaseFirestore.instance
          .collection('Sales')
          .doc(tahunLepas.toString())
          .get()
          .then((value) {
        graphTahunLepas.add(value);

        bulanLepas = graphTahunLepas[0]['December'];
        untungBulananTahunLepas.value = bulanLepas;
      });
    }
    percentBulanan.value =
        pengiraanPercentBulanan(bulanIni, bulanLepas).toStringAsFixed(2);
  }

  Future<void> getGraphFromFirestore() async {
    debugPrint('getting graph');
    final sales = FirebaseFirestore.instance.collection('Sales');
    graphJual = [];
    graphSupplier = [];
    await sales.doc(year).get().then((value) async {
      if (value.exists) {
        debugPrint('sales report exists');
        graphJual.add(value);
        await sales
            .doc(year)
            .collection('supplierRecord')
            .doc('record')
            .get()
            .then((value) {
          graphSupplier.add(value);
        });
        getGraphLength();
        jualanBulanIni();
        update();
      } else {
        debugPrint('generating sales report');
        Map<String, dynamic> data = {
          'January': 0,
          'February': 0,
          'March': 0,
          'April': 0,
          'May': 0,
          'June': 0,
          'July': 0,
          'August': 0,
          'September': 0,
          'October': 0,
          'November': 0,
          'December': 0,
        };
        await sales.doc(year).set(data);
        await sales
            .doc(year)
            .collection('supplierRecord')
            .doc('record')
            .set(data)
            .then((value) {
          getGraphLength();
          update();
        });
        update();
      }
    });
  }
}
