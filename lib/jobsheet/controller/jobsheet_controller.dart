import 'dart:math';
import 'package:admin_panel/API/firestore_api.dart';
import 'package:admin_panel/auth/controller/firebaseauth_controller.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:admin_panel/sms/controller/sms_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:get/get.dart';
import '../../API/notif_fcm.dart';

class JobsheetController extends GetxController {
  final _firestoreController = Get.find<FirestoreContoller>();
  final _authController = Get.find<AuthController>();
  final namaCust = TextEditingController();
  final noPhone = TextEditingController();
  final email = TextEditingController();
  final modelPhone = TextEditingController();
  final passPhone = TextEditingController();
  final kerosakkan = TextEditingController();
  final harga = TextEditingController();
  final remarks = TextEditingController();

  final focusNamaCust = FocusNode();
  final focusNoPhone = FocusNode();
  final focusEmail = FocusNode();
  final focusModelPhone = FocusNode();
  final focusPassPhone = FocusNode();
  final focusKerosakkan = FocusNode();
  final focusHarga = FocusNode();
  final focusRemarks = FocusNode();

  final FlutterContactPicker _contactPicker = FlutterContactPicker();

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
    if (mySID.value == '') {
      generateMySID();
    }
    checkExistingCust();
    focusNoPhone.addListener(() {
      debugPrint('tengah focus no phone');
    });

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

  void showShareJobsheet(Map<String, String?> data) {
    Get.bottomSheet(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('SMS Gateway'),
            subtitle: const Text('Hantar pemberitahuan SMS ke pelanggan ini'),
            onTap: () {
              Get.back();
              final smsController = Get.put(SMSController());
              smsController.recipientText.text = '6${noPhone.text}';
              smsController.messageText.text =
                  'Terima kasih kerana drop off peranti anda! Klik sini untuk menjejaki status repair peranti anda: af-fix.com/mysid?id=$mySID';
              Get.toNamed(MyRoutes.smsView);
            },
          ),
          ListTile(
            leading: const Icon(Icons.picture_as_pdf),
            title: const Text('Hasilkan PDF'),
            subtitle: const Text('Hasilkan PDF untuk maklumat jobsheet ini'),
            onTap: () {
              Get.toNamed(MyRoutes.pdfJobsheeetViewer, arguments: {
                'isReceipt': false,
                'timeStamp': Timestamp.fromDate(DateTime.now()),
                'technician': _authController.userName.value,
                'nama': namaCust.text,
                'noTel': noPhone.text,
                'model': modelPhone.text,
                'kerosakkan': kerosakkan.text,
                'price': harga.text,
                'remarks': remarks.text,
                'mysid': mySID.value,
                'email': data['email'],
              });
            },
          ),
        ],
      ),
      backgroundColor: Get.theme.canvasColor,
    );
  }

  Future<bool> exitJobSheet() async {
    Haptic.feedbackError();
    bool result = false;
    if (namaCust.text.isNotEmpty) {
      await Get.dialog(
        AlertDialog(
          title: const Text('Anda pasti untuk keluar?'),
          content: const Text(
              'Segala maklumat yang telah anda masukkan di Jobsheet ini akan di padam!'),
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
        await Future.delayed(const Duration(milliseconds: 300));
        focusNoPhone.requestFocus();
      }
    } else if (currentSteps.value == 1) {
      if (noPhone.text.isEmpty) {
        Haptic.feedbackError();
        errNoPhone.value = true;
      } else {
        currentSteps.value++;
        errNoPhone.value = false;
        await Future.delayed(const Duration(milliseconds: 300));
        focusEmail.requestFocus();
      }
    } else if (currentSteps.value == 2) {
      currentSteps.value++;
      await Future.delayed(const Duration(milliseconds: 300));
      focusModelPhone.requestFocus();
    } else if (currentSteps.value == 3) {
      if (modelPhone.text.isEmpty) {
        errModel.value = true;
        Haptic.feedbackError();
      } else {
        currentSteps.value++;
        errModel.value = false;
        await Future.delayed(const Duration(milliseconds: 300));
        focusPassPhone.requestFocus();
      }
    } else if (currentSteps.value == 4) {
      currentSteps.value++;
      await Future.delayed(const Duration(milliseconds: 300));
      focusKerosakkan.requestFocus();
    } else if (currentSteps.value == 5) {
      if (kerosakkan.text.isEmpty) {
        errKerosakkan.value = true;
        Haptic.feedbackError();
      } else {
        currentSteps.value++;
        errKerosakkan.value = false;
        await Future.delayed(const Duration(milliseconds: 300));
        focusHarga.requestFocus();
      }
    } else if (currentSteps.value == 6) {
      if (harga.text.isEmpty) {
        Haptic.feedbackError();
        errPrice.value = true;
      } else {
        currentSteps.value++;
        errPrice.value = false;
        await Future.delayed(const Duration(milliseconds: 300));
        focusRemarks.requestFocus();
      }
    } else if (currentSteps.value == 7) {
      Get.focusScope!.unfocus();
      Get.dialog(AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 30),
            const Text(
              'Menambah Jobsheet ke pangkalan data...',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Obx(() => Text(
                  'Status: ${_firestoreController.status.value}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
        // await DatabaseHelper.instance.addCustomerHistory(JobsheetHistoryModel(
        //   name: namaCust.text,
        //   noPhone: noPhone.text,
        //   email: email.text,
        //   model: modelPhone.text,
        //   password: passPhone.text,
        //   kerosakkan: kerosakkan.text,
        //   price: harga.text,
        //   remarks: remarks.text,
        //   userUID: mySID.value,
        // ));

        // await DatabaseHelper.instance
        //     .addNamaSuggestion(NamaSuggestion(nama: namaCust.text));
        // await DatabaseHelper.instance
        //     .addModelSuggestion(ModelSuggestion(model: modelPhone.text));
      }
      if (currentEmail.isEmpty) {
        currentEmail =
            '${userName.split(" ").join("").toLowerCase()}@email.com';
        debugPrint(currentEmail);
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
        technician: _authController.userName.toString(),
        remarks: remarks.text,
        isExisting: _data[0],
        userUID: _data[4],
      )
          .then((v) {
        if (v == 'operation-completed') {
          NotifFCM().postData('Resit Jobsheet telah dibuka!',
              'Juruteknik ${_authController.userName.value} telah membuka Resit Jobsheet');
          Haptic.feedbackSuccess();
          errFirestore.value = false;
          var payload = <String, String>{
            'nama': namaCust.text,
            'noTel': noPhone.text,
            'model': modelPhone.text,
            'kerosakkan': kerosakkan.text,
            'price': harga.text,
            'remarks': remarks.text,
            'mysid': mySID.value,
            'email': currentEmail,
            'technician': _authController.userName.value
          };

          Get.toNamed(MyRoutes.jobsheetDone, parameters: payload);

          ShowSnackbar.success('Operasi Selesai!',
              'Jobsheet telah ditambah ke pangkalan data', true);
        }
      }).catchError((err) async {
        Haptic.feedbackError();
        errFirestore.value = true;
        await Future.delayed(const Duration(seconds: 6));
        Get.focusScope!.unfocus();
        var payload = <String, String>{
          'nama': namaCust.text,
          'noTel': noPhone.text,
          'model': modelPhone.text,
          'kerosakkan': kerosakkan.text,
          'price': harga.text,
          'remarks': remarks.text,
          'mysid': mySID.value,
          'email': currentEmail,
        };
        Get.toNamed(MyRoutes.jobsheetDone, parameters: payload);
        ShowSnackbar.error('Kesalahan telah berlaku!', '$err', true);
      });
    }
  }

  void previousStep() {
    Get.focusScope!.unfocus();
    if (currentSteps.value > 0) {
      currentSteps.value = currentSteps.value - 1;
    } else {
      currentSteps.value = 0;
    }
  }

  void stepTap(int index) {
    Get.focusScope!.unfocus();
  }

  void selectContact() async {
    final contact = await _contactPicker.selectContact();
    if (contact != null) {
      String contactNum = contact.phoneNumbers!.first;
      namaCust.text = contact.fullName.toString();
      noPhone.text = contactNum
          .replaceAll('+6', '')
          .replaceAll(' ', '')
          .replaceAll('-', '');
    }
  }
}
