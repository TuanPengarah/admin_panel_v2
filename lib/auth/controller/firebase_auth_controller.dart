import 'dart:io';

import 'package:admin_panel/auth/model/technician_model.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:admin_panel/notification/controller/notification_controller.dart';
import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AuthController extends GetxController {
  final _auth = FirebaseAuth.instance;
  var userUID = ''.obs;
  var userEmail = ''.obs;
  var userName = '---'.obs;
  var photoURL = ''.obs;
  var jawatan = ''.obs;
  var cawangan = ''.obs;
  var jumlahRepair = 0.obs;
  var jumlahKeuntungan = 0.obs;
  String? token = '';

  @override
  void onReady() {
    final user = _auth.currentUser;
    if (user != null) {
      checkUserData(user.email.toString());
    }
    if (kIsWeb) {
      if (user != null) {
        Get.offAllNamed(MyRoutes.home);
      } else {
        Get.offAndToNamed(MyRoutes.login);
      }
    }

    super.onReady();
  }

  ///LOGIN
  void performLogin(String email, String password,
      RoundedLoadingButtonController btnController) async {
    Haptic.feedbackClick();

    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (kIsWeb) {
        await _auth
            .setPersistence(Persistence.LOCAL)
            .then((value) => debugPrint('persist set to local on web'));
      }
      await FirebaseDatabase.instance
          .ref()
          .child('Technician')
          .child(user.user!.uid)
          .once()
          .then((snapshot) async {
        if (snapshot.snapshot.value == null || !snapshot.snapshot.exists) {
          await _auth.signOut();
          ShowSnackbar.error(
              'You shall not pass!!🧙🪄',
              'Nampaknya anda bukan staff Af-Fix! Untuk mengetahui lebih lanjut, Sila hubungi bos anda (Akid Fikri Azhar)',
              true);
          btnController.error();
          Haptic.feedbackError();
          await Future.delayed(const Duration(seconds: 2));
          btnController.reset();
        } else {
          await checkUserData(user.user!.email.toString());

          btnController.success();
          Haptic.feedbackSuccess();
          await Future.delayed(const Duration(seconds: 1));
          Get.offAllNamed('/home');
          ShowSnackbar.success(
              'Selamat Kembali $userName', 'Log masuk berjaya!', true);
        }
      });
    } on FirebaseAuthException catch (err) {
      ShowSnackbar.error('Kesalahan telah berlaku!', err.toString(), true);
      btnController.error();
      Haptic.feedbackError();
      await Future.delayed(const Duration(seconds: 2));
      btnController.reset();
      return;
    }
  }

  ///LOG OUT
  void performLogOut() {
    Haptic.feedbackError();
    Get.dialog(
      AlertDialog(
        title: const Text('Log Keluar'),
        content: const Text('Adakah anda pasti untuk log keluar?'),
        actions: [
          TextButton(
            child: Text(
              'Log Keluar',
              style: TextStyle(
                color: Colors.amber[900],
              ),
            ),
            onPressed: () {
              _auth.signOut().then((value) async {
                if (!GetPlatform.isWeb) {
                  Directory documentDirectory =
                      await getApplicationDocumentsDirectory();
                  String path =
                      join(documentDirectory.path, '${userUID.value}.db');
                  File file = File(path);
                  bool checkFile = await File(path).exists();
                  if (checkFile == true) {
                    final destination = 'database/SQLite/${userUID.value}.db';
                    final ref = FirebaseStorage.instance.ref(destination);
                    await ref.putFile(file);
                  }
                }
                userUID.value = '';
                userEmail.value = '';
                userName.value = '---';
                cawangan.value = '';
                jumlahRepair.value = 0;
                jumlahKeuntungan.value = 0;
                Get.offAllNamed(MyRoutes.login);
                Haptic.feedbackSuccess();
                ShowSnackbar.success(
                    'Log Keluar Berjaya', 'Anda telah di log keluar!', true);
              }).catchError((err) {
                Haptic.feedbackError();
                ShowSnackbar.error(
                    'Kesalahan telah berlaku', err.toString(), true);
              });
            },
          ),
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  Future<void> checkUserData(String email) async {
    final box = GetStorage();
    final notifController = Get.put(NotificationController());
    final user = FirebaseAuth.instance.currentUser;
    bool internet = true;
    var connect = await ConnectivityWrapper.instance.isConnected;

    if (GetPlatform.isWeb) {
      internet = true;
    } else {
      internet = connect;
    }

    if (internet == true) {
      await FirebaseDatabase.instance
          .ref()
          .child('Technician')
          .child(user!.uid)
          .once()
          .then((snapshot) async {
        final json = snapshot.snapshot.value as Map<dynamic, dynamic>;
        final technician = Technician.fromJson(json);
        userUID.value = user.uid;
        userEmail.value = email;
        userName.value = technician.nama;
        cawangan.value = technician.cawangan;
        jumlahRepair.value = technician.jumlahRepair;
        jumlahKeuntungan.value = technician.jumlahKeuntungan;
        jawatan.value = technician.jawatan;
        photoURL.value = technician.photoURL;
        token = technician.token;
        box.write('userUID', user.uid);
        box.write('userEmail', email);
        box.write('userName', technician.nama);
        box.write('cawangan', technician.cawangan);
        box.write('jumlahRepair', technician.jumlahRepair);
        box.write('jumlahKeuntungan', technician.jumlahKeuntungan);
        box.write('jawatan', technician.jawatan);
        box.write('photoURL', technician.photoURL);
        box.write('token', technician.token);

        //notification config
        if (!GetPlatform.isWeb) {
          if (box.read<bool>('initNotif') == true) {
            notifController.subscribedToFCM('socmed');
            if (jawatan.value == 'Founder') {
              debugPrint('Notifikasi settlement telah diset kan sekali');
              notifController.subscribedToFCM('settlement');
            } else {
              notifController.unsubscribedFromFCM('settlement');
            }
          } else {
            notifController.unsubscribedFromFCM('socmed');
            if (jawatan.value == 'Founder') {
              debugPrint('Notifikasi settlement akan dibatalkan sekali');
              notifController.unsubscribedFromFCM('settlement');
            } else {
              notifController.unsubscribedFromFCM('settlement');
            }
          }
        }
        final String? deviceToken = await FirebaseMessaging.instance.getToken();
        debugPrint('your new device token: $deviceToken');

        if (token != deviceToken) {
          debugPrint('tukar token baru: $deviceToken');
          token = deviceToken;
          FirebaseDatabase.instance
              .ref()
              .child('Technician')
              .child(user.uid)
              .update({'token': deviceToken});
        }
      });
    } else {
      ShowSnackbar.error('Gagal untuk menyambung ke rangkaian',
          'Pastikan peranti anda telah disambungkan ke rangkaian', true);

      userUID.value = box.read('userUID');
      userEmail.value = box.read('userEmail');
      userName.value = box.read('userName');
      cawangan.value = box.read('cawangan');
      jumlahRepair.value = box.read<int>('jumlahRepair') ?? 0;
      jumlahKeuntungan.value = box.read<int>('jumlahKeuntungan') ?? 0;
      jawatan.value = box.read('jawatan');
      photoURL.value = box.read('photoURL');
      token = box.read('token');
    }
  }
}
