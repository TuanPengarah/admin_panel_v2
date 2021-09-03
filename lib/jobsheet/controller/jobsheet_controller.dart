import 'dart:math';
import 'package:admin_panel/API/firestoreAPI.dart';
import 'package:admin_panel/API/sqlite.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:admin_panel/jobsheet/model/jobsheet_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class JobsheetController extends GetxController {
  final _firestoreController = Get.put(FirestoreContoller());

  final namaCust = TextEditingController();
  final noPhone = TextEditingController();
  final email = TextEditingController();
  final modelPhone = TextEditingController();
  final passPhone = TextEditingController();
  final kerosakkan = TextEditingController();
  final harga = TextEditingController();
  final remarks = TextEditingController();

  final FlutterContactPicker _contactPicker = new FlutterContactPicker();

  var errNama = false.obs;
  var errNoPhone = false.obs;
  var errModel = false.obs;
  var errKerosakkan = false.obs;
  var errPrice = false.obs;
  var errFirestore = true.obs;

  var currentSteps = 0.obs;

  var mySID = ''.obs;

  final _data = Get.arguments;

  @override
  void onInit() {
    generateMySID();
    checkExistingCust();
    super.onInit();
  }

  void checkExistingCust() {
    if (_data[0] == true) {
      namaCust.text = _data[1];
      noPhone.text = _data[2];
      email.text = _data[3];
      currentSteps.value = 3;
    }
  }

  void showShareJobsheet() {
    Get.bottomSheet(
      Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.print),
              title: Text('Print'),
              subtitle: Text('Print maklumat Jobsheet ini!'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.picture_as_pdf),
              title: Text('PDF'),
              subtitle: Text('Hasilkan maklumat Jobsheet berformat PDF!'),
              onTap: () => Get.toNamed(MyRoutes.pdfviewer),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<bool> exitJobSheet() async {
    Haptic.feedbackError();
    bool result = false;
    if (namaCust.text.isNotEmpty) {
      await Get.dialog(
        AlertDialog(
          title: Text('Anda pasti untuk keluar?'),
          content: Text(
              'Segala maklumat yang telah anda masukkan di Jobsheet ini akan di padam!'),
          actions: [
            TextButton(
              onPressed: () {
                result = false;
                Get.back();
              },
              child: Text('Batal'),
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

  void generateMySID() {
    var random = Random();
    String converter = random.nextInt(999999).toString().padLeft(6, '0');
    mySID.value = converter;
  }

  void nextStep() async {
    Haptic.feedbackClick();
    if (currentSteps.value == 0) {
      if (namaCust.text.isEmpty) {
        Haptic.feedbackError();
        errNama.value = true;
      } else {
        currentSteps.value++;
        errNama.value = false;
      }
    } else if (currentSteps.value == 1) {
      if (noPhone.text.isEmpty) {
        Haptic.feedbackError();
        errNoPhone.value = true;
      } else {
        currentSteps.value++;
        errNoPhone.value = false;
      }
    } else if (currentSteps.value == 2) {
      currentSteps.value++;
    } else if (currentSteps.value == 3) {
      if (modelPhone.text.isEmpty) {
        errModel.value = true;
        Haptic.feedbackError();
      } else {
        currentSteps.value++;
        errModel.value = false;
      }
    } else if (currentSteps.value == 4) {
      currentSteps.value++;
    } else if (currentSteps.value == 5) {
      if (kerosakkan.text.isEmpty) {
        errKerosakkan.value = true;
        Haptic.feedbackError();
      } else {
        currentSteps.value++;
        errKerosakkan.value = false;
      }
    } else if (currentSteps.value == 6) {
      if (harga.text.isEmpty) {
        Haptic.feedbackError();
        errPrice.value = true;
      } else {
        currentSteps.value++;
        errPrice.value = false;
      }
    } else if (currentSteps.value == 7) {
      Get.focusScope.unfocus();
      Get.dialog(AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 30),
            Text(
              'Menambah Jobsheet ke pangkalan data...',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            Obx(() => Text(
                  'Status: ${_firestoreController.status.value}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                )),
          ],
        ),
      ));
      String currentEmail = email.text;
      String userName = namaCust.text;

      if (kIsWeb == false) {
        await DatabaseHelper.instance.add(JobsheetHistoryModel(
          name: namaCust.text,
          noPhone: noPhone.text,
          email: email.text,
          model: modelPhone.text,
          password: passPhone.text,
          kerosakkan: kerosakkan.text,
          price: harga.text,
          remarks: remarks.text,
          userUID: '',
        ));
      }
      if (currentEmail.isEmpty) {
        currentEmail =
            userName.split(" ").join("").toLowerCase() + '@email.com';
        print(currentEmail);
      }
      await _firestoreController
          .addJobSheet(
        email: currentEmail,
        nama: namaCust.text,
        noPhone: noPhone.text,
        mysid: mySID.value,
        model: modelPhone.text,
        password: passPhone.text,
        kerosakkan: kerosakkan.text,
        harga: int.parse(harga.text),
        technician: 'Akid Fikri Azhar',
        remarks: remarks.text,
        isExisting: _data[0],
        userUID: _data[4],
      )
          .then((v) {
        if (v == 'operation-completed') {
          Haptic.feedbackSuccess();
          errFirestore.value = false;
          Get.toNamed(MyRoutes.jobsheetDone);
          ShowSnackbar.success('Operasi Selesai!',
              'Jobsheet telah ditambah ke pangkalan data', true);
        }
      }).catchError((err) async {
        Haptic.feedbackError();
        errFirestore.value = true;
        await Future.delayed(Duration(seconds: 6));
        Get.focusScope.unfocus();
        Get.toNamed(MyRoutes.jobsheetDone);
        ShowSnackbar.error('Kesalahan telah berlaku!', '$err', true);
      });
    }
  }

  void previousStep() {
    Get.focusScope.unfocus();
    if (currentSteps.value > 0) {
      currentSteps.value = currentSteps.value - 1;
    } else {
      currentSteps.value = 0;
    }
  }

  void stepTap(int index) {
    Get.focusScope.unfocus();
  }

  void selectContact() async {
    final contact = await _contactPicker.selectContact();
    if (contact != null) {
      namaCust.text = contact.fullName;
      noPhone.text = contact.phoneNumbers.first;
    }
  }
}
