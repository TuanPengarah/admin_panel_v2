import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class RepairHistoryController extends GetxController {
  final _data = Get.arguments;
  List items = [];
  var totalPrice = ''.obs;
  @override
  void onInit() {
    getFromFirestore();
    super.onInit();
  }

  Future<void> getFromFirestore() async {
    double sum = 0.0;
    await FirebaseFirestore.instance
        .collection('customer')
        .doc(_data[0])
        .collection('repair history')
        .orderBy('timeStamp', descending: true)
        .get()
        .then((snapshot) => items = snapshot.docs);

    items.forEach((item) {
      if (item['Status'] == 'Selesai') {
        sum += item['Harga'];
      }
    });
    totalPrice.value = sum.toString();
  }
}
