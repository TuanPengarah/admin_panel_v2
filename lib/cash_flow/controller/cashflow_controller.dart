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
  var isModal = true.obs;
  var isSparepart = true.obs;
  var isJualPhone = true.obs;

  final hargaText = TextEditingController();
  final remarksText = TextEditingController();

  Future? initCashFlow;

  @override
  void onInit() {
    initCashFlow = getCashFlow();
    super.onInit();
  }

  Future<void> deleteCashFlow(String docid) async {
    Get.dialog(AlertDialog(
      title: const Text('Adakah anda pasti?'),
      content: const Text(
        'Adakah anda pasti untuk membuang cash flow ini (Pastikan anda check pada graph database!)',
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection('Sales')
                .doc(year)
                .collection('cashFlow')
                .doc(docid)
                .delete()
                .then((value) async {
              await getCashFlow();
              Get.back();
              Get.back();
              update();
            });
          },
          child: const Text('Pasti'),
        ),
        TextButton(
          onPressed: Get.back,
          child: Text(
            'Batal',
            style: TextStyle(color: Get.theme.colorScheme.error),
          ),
        ),
      ],
    ));
  }

  Future<void> editCashFlow(
      String docID, bool jualPhoneKe, bool sparepartKe) async {
    Haptic.feedbackClick();
    Map<String, dynamic> data = {
      'isSpareparts': sparepartKe,
      'isModal': isModal.value,
      'isJualPhone': jualPhoneKe,
      'jumlah': double.parse(hargaText.text),
      'remark': remarksText.text,
    };

    Get.dialog(const AlertDialog(
      title: Text('Melakukan Perubahan...'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [CircularProgressIndicator.adaptive()],
      ),
    ));

    await FirebaseFirestore.instance
        .collection('Sales')
        .doc(year)
        .collection('cashFlow')
        .doc(docID)
        .update(data)
        .whenComplete(() async {
      await getCashFlow();
      Get.back();
      update();
    });
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
      for (var doc in snapshot.docs) {
        // DateTime dt = (doc['timeStamp'] as Timestamp).toDate();
        // FirebaseFirestore.instance
        //     .collection('Sales')
        //     .doc(year)
        //     .collection('cashFlow')
        //     .doc(doc.id)
        //     .update({
        //   'isJualPhone': false,
        //   'isSpareparts': true,
        // });

        cashFlow.add(CashFlowModel.fromJson(doc));
      }
    });
    // cashFlow.forEach((element) {
    //   masuk.value += element.isModal == false
    //       ? double.parse(element.jumlah.toString())
    //       : 0;
    //   keluar.value +=
    //       element.isModal == true ? double.parse(element.jumlah.toString()) : 0;
    //   total.value = double.parse(masuk.value.toString()) -
    //       double.parse(keluar.value.toString());
    // });

    for (var cash in cashFlow) {
      masuk.value +=
          cash.isModal == false ? double.parse(cash.jumlah.toString()) : 0;
      keluar.value +=
          cash.isModal == true ? double.parse(cash.jumlah.toString()) : 0;
      total.value = double.parse(masuk.value.toString()) -
          double.parse(keluar.value.toString());
    }
    cashFlow.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
    update();
  }

  Future<void> addCashFlow() async {
    var status = 'Menambah data pada Cash Flow...'.obs;
    Get.dialog(
      AlertDialog(
        title: const Text('Menambah Cash Flow'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.grey),
            const SizedBox(height: 10),
            Obx(() {
              return Text(
                status.value,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              );
            }),
          ],
        ),
      ),
    );
    final graphController = Get.find<GraphController>();
    double hargaRaw = double.parse(hargaText.text);
    int harga = int.parse(hargaRaw.toStringAsFixed(0));
    final String months =
        graphController.checkMonths(DateTime.now().month - 1);
    var firestore = FirebaseFirestore.instance.collection('Sales').doc(year);
    Map<String, dynamic> cashflowPayload = {
      'remark': remarksText.text,
      'jumlah': harga,
      'isModal': isModal.value,
      'timeStamp': FieldValue.serverTimestamp(),
      'isSpareparts': isSparepart.value,
      'isJualPhone': isJualPhone.value,
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

          double newPoint = double.parse(snap.get(months).toString());

          transaction.update(ref, {months: newPoint + harga});
        });
      } else if (isModal.value == false) {
        FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snap = await transaction.get(firestore);

          if (!snap.exists) {
            throw Exception("Harga untung tidak dijumpai");
          }

          double newPoint = double.parse(snap.get(months).toString());

          transaction.update(firestore, {months: newPoint + harga});
        });
      }

      status.value = 'Mengemaskini status....';

      await getCashFlow();
      await graphController.getGraphFromFirestore();
      update();
      status.value = 'Selesai';
      Get.back();
      resetAdd();
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
    hargaText.text = '';
    remarksText.text = '';
    isModal.value = true;
    isSparepart.value = true;
    isJualPhone.value = true;
  }
}
