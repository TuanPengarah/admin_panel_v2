import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GraphController extends GetxController {
  String year = DateFormat('yyyy').format(DateTime.now()).toString();
  List graphJual = [];
  List graphSupplier = [];
  List<FlSpot> spotJual = [];
  List<FlSpot> spotSupplier = [];

  var jumlahBulanan = 0.obs;
  var untungBersih = 0.obs;
  var untungKasar = 0.obs;
  var jumlahModal = 0.obs;

  Future getGraph;
  @override
  void onInit() {
    getGraph = getGraphFromFirestore();
    super.onInit();
  }

  double findY(double untungKasar, double modal) {
    if (untungKasar < modal) {
      return modal;
    } else
      return untungKasar;
  }

  String checkMonths(int i) {
    switch (i) {
      case 0:
        return 'January';
        break;
      case 1:
        return 'February';
        break;
      case 2:
        return 'March';
        break;
      case 3:
        return 'April';
        break;
      case 4:
        return 'May';
        break;
      case 5:
        return 'June';
        break;
      case 6:
        return 'July';
        break;
      case 7:
        return 'August';
        break;
      case 8:
        return 'September';
        break;
      case 9:
        return 'October';
        break;
      case 10:
        return 'November';
        break;
      case 11:
        return 'December';
        break;
      default:
        return 'December';
    }
  }

  int getMonthsHargajual() {
    return graphSupplier[0][checkMonths(DateTime.now().month - 1)];
  }

  int getMonthsUntungBersih() {
    return jumlahBulanan.value - getMonthsHargajual();
  }

  void getGraphLength() {
    spotJual = [];
    spotSupplier = [];
    jumlahModal.value = 0;
    untungKasar.value = 0;
    for (int i = 0; i < DateTime.now().month; i++) {
      spotJual.add(
        FlSpot(i.toDouble(), graphJual[0][checkMonths(i)].toDouble()),
      );
      untungKasar.value += graphJual[0][checkMonths(i)];
    }
    for (int i = 0; i < DateTime.now().month; i++) {
      spotSupplier.add(
        FlSpot(i.toDouble(), graphSupplier[0][checkMonths(i)].toDouble()),
      );
      jumlahModal.value += graphSupplier[0][checkMonths(i)];
    }

    jumlahBulanan.value = graphJual[0][checkMonths(DateTime.now().month - 1)];
    untungBersih.value = untungKasar.value - jumlahModal.value;
  }

  Future<void> getGraphFromFirestore() async {
    final sales = FirebaseFirestore.instance.collection('Sales');
    graphJual = [];
    graphSupplier = [];
    await sales.doc(year).get().then((value) async {
      if (value.exists) {
        print('sales report exists');
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
        update();
      } else {
        print('generating sales report');
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
