import 'package:admin_panel/cash_flow/model/cashflow_model.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:admin_panel/graph/graph_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CashFlowController extends GetxController {
  String year = DateFormat('yyyy').format(DateTime.now()).toString();
  List<CashFlowModel> cashFlow = [];
  String yes = 'Year';
  var masuk = 0.0.obs;
  var keluar = 0.0.obs;
  var total = 0.0.obs;
  var isModal = false.obs;

  final hargaText = TextEditingController();
  final remarksText = TextEditingController();

  Future initCashFlow;

  @override
  void onInit() {
    initCashFlow = getCashFlow();
    super.onInit();
  }

  Future<void> getCashFlow() async {
    cashFlow.clear();
    masuk = 0.0.obs;
    keluar = 0.0.obs;
    total = 0.0.obs;
    await FirebaseFirestore.instance
        .collection('Sales')
        .doc(year)
        .collection('cashFlow')
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((doc) {
        CashFlowModel model = CashFlowModel(
            id: doc.id,
            remark: doc['remark'],
            jumlah: doc['jumlah'],
            isModal: doc['isModal'],
            timeStamp: doc['timeStamp']);
        cashFlow.add(model);
      });
    });
    cashFlow.forEach((element) {
      masuk.value += element.isModal == false
          ? double.parse(element.jumlah.toString())
          : 0;
      keluar.value +=
          element.isModal == true ? double.parse(element.jumlah.toString()) : 0;
      total.value = double.parse(masuk.value.toString()) -
          double.parse(keluar.value.toString());
    });
    cashFlow..sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
    update();
  }

  Future<void> addCashFlow() async {
    var status = 'Menambah data pada Cash Flow...'.obs;
    Get.dialog(
      AlertDialog(
        title: Text('Menambah Cash Flow'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.grey),
            SizedBox(height: 10),
            Obx(() {
              return Text(
                status.value,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              );
            }),
          ],
        ),
      ),
    );
    final _graphController = Get.find<GraphController>();
    double hargaRaw = double.parse(hargaText.text);
    int harga = int.parse(hargaRaw.toStringAsFixed(0));
    final String months =
        _graphController.checkMonths(DateTime.now().month - 1);
    var firestore = FirebaseFirestore.instance.collection('Sales').doc(year);
    Map<String, dynamic> cashflowPayload = {
      'remark': remarksText.text,
      'jumlah': harga,
      'isModal': isModal.value,
      'timeStamp': FieldValue.serverTimestamp(),
    };
    try {
      await firestore.collection('cashFlow').add(cashflowPayload);

      status.value = 'Tambah pada graph sales....';
      if (isModal.value == true) {
        DocumentReference ref =
            firestore.collection('supplierRecord').doc('record');

        FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snap = await transaction.get(ref);

          if (!snap.exists) {
            throw Exception("Harga modal tidak dijumpai");
          }

          int newPoint = snap.get(months);

          transaction.update(ref, {months: newPoint + harga});
        });
      } else if (isModal.value == false) {
        FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snap = await transaction.get(firestore);

          if (!snap.exists) {
            throw Exception("Harga untung tidak dijumpai");
          }

          int newPoint = snap.get(months);

          transaction.update(firestore, {months: newPoint + harga});
        });
      }

      status.value = 'Mengemaskini status....';

      await getCashFlow();
      await _graphController.getGraphFromFirestore();
      update();
      status.value = 'Selesai';
      Get.back();
      Haptic.feedbackSuccess();
      ShowSnackbar.success(
          'Selesai', 'Cash Flow telah ditambah pada pangkalan data', false);
    } on FirebaseException catch (e) {
      Get.back();
      Haptic.feedbackError();
      ShowSnackbar.error('Kesalahan telah berlaku', e.toString(), false);
    }
  }

  void resetAdd() {
    Get.back();
    hargaText.text = '';
    remarksText.text = '';
    isModal.value = false;
  }
}
