import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GraphController extends GetxController {
  String year = DateFormat('yyyy').format(DateTime.now()).toString();
  List graph = [];
  List<FlSpot> spot = [];
  Future getGraph;
  @override
  void onInit() {
    getGraph = getGraphFromFirestore();
    super.onInit();
  }

  String checkMonths(int i) {
    switch (i) {
      case 1:
        return 'January';
        break;
      case 2:
        return 'February';
        break;
      case 3:
        return 'March';
        break;
      case 4:
        return 'April';
        break;
      case 5:
        return 'May';
        break;
      case 6:
        return 'June';
        break;
      case 7:
        return 'July';
        break;
      case 8:
        return 'August';
        break;
      case 9:
        return 'September';
        break;
      case 10:
        return 'October';
        break;
      case 11:
        return 'November';
        break;
      case 12:
        return 'December';
        break;
      default:
        return 'December';
    }
  }

  void getGraphLength() {
    spot = [];
    for (int i = 0; i < DateTime.now().month; i++) {
      spot.add(
        FlSpot(i.toDouble(), graph[0][checkMonths(i = -1)].toDouble()),
      );
    }
  }

  Future<void> getGraphFromFirestore() async {
    final sales = FirebaseFirestore.instance.collection('Sales');
    graph = [];
    await sales.doc(year).get().then((value) async {
      if (value.exists) {
        print('sales report exists');
        graph.add(value);
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
        getGraphLength();
        update();
      }
    });
  }
}
