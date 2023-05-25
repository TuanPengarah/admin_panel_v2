import 'dart:math';
import 'package:admin_panel/API/notif_fcm_event.dart';
import 'package:admin_panel/auth/controller/firebaseauth_controller.dart';
import 'package:admin_panel/calculator/controller/price_calc_controller.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:admin_panel/graph/graph_controller.dart';
import 'package:admin_panel/home/controller/sparepart_controller.dart';
import 'package:admin_panel/price_list/controller/pricelist_controller.dart';
import 'package:admin_panel/spareparts/model/sparepart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../config/routes.dart';

class AddSparepartsController extends GetxController {
  final _sparepartsController = Get.find<SparepartController>();
  final _authController = Get.find<AuthController>();
  final _priceListController = Get.find<PriceListController>();

  final modelParts = TextEditingController();
  final jenisParts = TextEditingController();
  final hargaParts = TextEditingController();
  final maklumatParts = TextEditingController();
  final kuantitiParts = TextEditingController(text: '1');

  var selectedSupplier = 'MG'.obs;
  var selectedQuality = 'OEM'.obs;

  var currentSteps = 0.obs;
  var timeStamp = ''.obs;
  var partsID = ''.obs;
  var status = ''.obs;

  final focusJenisSparepart = FocusNode();
  final focusModelSmartphone = FocusNode();
  final focusHargaParts = FocusNode();
  final focusMaklumatParts = FocusNode();
  final focusKuantitiParts = FocusNode();

  var errModelParts = false.obs;
  var errJenisParts = false.obs;
  var errHargaParts = false.obs;
  var errMaklumatParts = false.obs;
  var errKuantitiParts = false.obs;

  @override
  void onInit() {
    generateTimestamp();
    generatePartsID();
    super.onInit();
  }

  Future<bool> exitSpareparts() async {
    Haptic.feedbackError();
    bool result = false;
    if (modelParts.text.isNotEmpty) {
      await Get.dialog(
        AlertDialog(
          title: const Text('Anda pasti untuk keluar?'),
          content: const Text(
              'Segala maklumat yang telah anda masukkan di Spareparts ini akan di padam!'),
          actions: [
            TextButton(
              onPressed: () {
                result = false;
                Get.back();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                result = true;
                Get.back();
              },
              child: Text(
                'Keluar',
                style: TextStyle(
                  color: Colors.amber[900],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      result = true;
    }
    return result;
  }

  void generateTimestamp() {
    var dateID = DateTime.now().millisecondsSinceEpoch.toString();
    timeStamp.value = dateID;
  }

  void generatePartsID() {
    var random = Random();
    String converter = random.nextInt(999999).toString().padLeft(6, '0');
    partsID.value = converter;
  }

  void nextStepper() async {
    // final lastStep =
    //     currentSteps.value == AddSparepartStepper().getStepper().length - 1;
    Haptic.feedbackClick();
    if (currentSteps.value == 0) {
      currentSteps += 1;
      await Future.delayed(const Duration(milliseconds: 300));
      Get.focusScope?.requestFocus(focusModelSmartphone);
    } else if (currentSteps.value == 1) {
      if (modelParts.text.isEmpty) {
        errModelParts.value = true;
      } else {
        currentSteps += 1;
        errModelParts.value = false;
        await Future.delayed(const Duration(milliseconds: 300));
        focusJenisSparepart.requestFocus();
      }
    } else if (currentSteps.value == 2) {
      if (jenisParts.text.isEmpty) {
        errJenisParts.value = true;
      } else {
        currentSteps += 1;
        errJenisParts.value = false;

        focusJenisSparepart.unfocus();
      }
    } else if (currentSteps.value == 3) {
      await Future.delayed(const Duration(milliseconds: 300));
      focusHargaParts.requestFocus();
      currentSteps += 1;
    } else if (currentSteps.value == 4) {
      if (hargaParts.text.isEmpty) {
        errHargaParts.value = true;
      } else {
        currentSteps += 1;
        errHargaParts.value = false;
        await Future.delayed(const Duration(milliseconds: 300));
        focusMaklumatParts.requestFocus();
      }
    } else if (currentSteps.value == 5) {
      if (maklumatParts.text.isEmpty) {
        errMaklumatParts.value = true;
      } else {
        currentSteps += 1;
        errMaklumatParts.value = false;
        await Future.delayed(const Duration(milliseconds: 300));
        focusKuantitiParts.requestFocus();
      }
    } else if (currentSteps.value == 6) {
      if (kuantitiParts.text.isEmpty) {
        errKuantitiParts.value = true;
      } else {
        currentSteps += 1;
        errKuantitiParts.value = false;
        focusKuantitiParts.unfocus();
      }
    } else if (currentSteps.value == 7) {
      addToRTDB();
    }
  }

  void backStepper() {
    Haptic.feedbackError();
    Get.focusScope?.unfocus();
    currentSteps -= 1;
  }

  Future<void> addToRTDB() async {
    final graphController = Get.find<GraphController>();
    status.value = 'Menyediakan maklumat spareparts anda...';

    Get.dialog(AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 30),
          Obx(() => Text(
                status.value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              )),
        ],
      ),
    ));

    try {
      if (!kIsWeb) {
        // await DatabaseHelper.instance.addSparepartsHistory(
        //   Spareparts(
        //     model: modelParts.text,
        //     jenisSpareparts: jenisParts.text,
        //     supplier: selectedSupplier.value,
        //     kualiti: selectedQuality.value,
        //     maklumatSpareparts: maklumatParts.text,
        //     tarikh: timeStamp.value,
        //     harga: hargaParts.text,
        //     partsID: partsID.value,
        //   ),
        // );
        // await DatabaseHelper.instance
        //     .addPartsSuggestion(PartsSuggestion(parts: jenisParts.text));
        // await DatabaseHelper.instance
        //     .addModelSuggestion(ModelSuggestion(model: modelParts.text));
      }
      var firestore = FirebaseFirestore.instance;
      for (int i = 0; i < int.parse(kuantitiParts.text); i++) {
        generatePartsID();
        Spareparts spareparts = Spareparts(
          model: modelParts.text,
          jenisSpareparts: jenisParts.text,
          supplier: selectedSupplier.value,
          kualiti: selectedQuality.value,
          maklumatSpareparts: maklumatParts.text,
          tarikh: timeStamp.value,
          harga: hargaParts.text,
          partsID: partsID.value,
        );
        await Future.delayed(const Duration(milliseconds: 100));
        status.value =
            'Memasukkan maklumat spareparts anda ke pangkalan data...';
        await FirebaseDatabase.instance
            .ref()
            .child('Spareparts')
            .child(partsID.value)
            .set(spareparts.toJson());

        //TAMBAH MODAL PADA GRAPH SALES

        String months = graphController.checkMonths(DateTime.now().month - 1);
        status.value = 'Menambah harga modal pada graph sales...';
        DocumentReference hargaModal = firestore
            .collection('Sales')
            .doc(graphController.year)
            .collection('supplierRecord')
            .doc('record');
        firestore.runTransaction((transaction) async {
          DocumentSnapshot snap = await transaction.get(hargaModal);

          if (!snap.exists) {
            throw Exception("Harga modal tidak dijumpai");
          }

          double newPoints = double.parse(snap.get(months).toString());
          transaction.update(
              hargaModal, {months: newPoints + double.parse(hargaParts.text)});
        });

        //TAMBAH PADA CASH FLOW
        status.value = 'Mengemaskini cash flow...';
        final Map<String, dynamic> cashflow = {
          'jumlah': double.parse(hargaParts.text),
          'isModal': true,
          'isSpareparts': false,
          'isJualPhone': true,
          'remark': '${jenisParts.text} ${modelParts.text}',
          'timeStamp': FieldValue.serverTimestamp(),
        };

        await firestore
            .collection('Sales')
            .doc(graphController.year)
            .collection('cashFlow')
            .add(cashflow);
      }

      status.value = 'Menyegarkan semula semua data...';
      await _sparepartsController.refreshDialog(false);
      await graphController.getGraphFromFirestore();
      NotifFCMEvent().postData(
        'Sparepart telah ditambah!',
        'Sparepart ${jenisParts.text} ${modelParts.text} telah dimasukkan ke inventori anda dengan bernilai RM${hargaParts.text}',
        token: _authController.token,
      );
      status.value = 'Selesai!';
      Haptic.feedbackSuccess();
      await Future.delayed(const Duration(seconds: 1));
      Get.offAllNamed(MyRoutes.home);
      final bool exist = _priceListController.priceList.any((item) =>
          item.parts.contains(jenisParts.text) &&
          item.model.contains(modelParts.text));
      debugPrint(exist.toString());
      if (exist == false) {
        showRecommended();
      }
    } on Exception catch (e) {
      status.value = 'Opps! Kesalahan talah berlaku: $e';
      Haptic.feedbackError();
      await Future.delayed(const Duration(seconds: 2));
      Get.back();
      ShowSnackbar.error('Gagal untuk menambah spareparts',
          'Kesalahan telah berlaku: $e', false);
    }
  }

  void showRecommended() {
    final addPriceList = Get.put(PriceListController());
    final calc = Get.put(PriceCalculatorController());
    Get.dialog(
      AlertDialog(
        title: const Text('Tambah ke senarai harga'),
        content: const Text(
            'Adakah anda ingin memasukkan harga sparepart tersebut ke senarai harga? (Sila tekan batal jika sparepart tersebut telah wujud di senarai harga)'),
        actions: [
          TextButton(
            onPressed: () {
              Haptic.feedbackError();
              Get.closeAllSnackbars();
              Get.back();
            },
            child: Text(
              'Batal',
              style: TextStyle(color: Colors.amber[900]),
            ),
          ),
          TextButton(
            onPressed: () {
              Haptic.feedbackClick();
              Get.back();
              double harga =
                  calc.calculateFromWidget(double.parse(hargaParts.text));
              addPriceList.modelText.text = modelParts.text;
              addPriceList.partsText.text = jenisParts.text;
              addPriceList.priceText.text = harga.toStringAsFixed(0);
              addPriceList.addListDialog(isEdit: false);
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }
}
