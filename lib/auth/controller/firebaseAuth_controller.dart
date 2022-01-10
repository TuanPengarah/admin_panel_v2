import 'dart:io';

import 'package:admin_panel/auth/model/technician_model.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:admin_panel/notification/controller/notification_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
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
  String token = '';

  @override
  void onReady() {
    final user = _auth.currentUser;
    if (user != null) {
      checkUserData(user.uid, user.email);
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
    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      if (kIsWeb) {
        await _auth
            .setPersistence(Persistence.LOCAL)
            .then((value) => print('persist set to local on web'));
      }

      await FirebaseDatabase.instance
          .reference()
          .child('Technician')
          .child(value.user.uid)
          .once()
          .then((snapshot) async {
        if (snapshot.value == null || !snapshot.exists) {
          await _auth.signOut();
          ShowSnackbar.error(
              'You shall not pass!!🧙🪄',
              'Nampaknya anda bukan staff Af-Fix! Untuk mengetahui lebih lanjut, Sila hubungi bos anda (Akid Fikri Azhar)',
              true);
          btnController.error();
          Haptic.feedbackError();
          await Future.delayed(Duration(seconds: 2));
          btnController.reset();
        } else {
          await checkUserData(value.user.uid, value.user.email);

          btnController.success();
          Haptic.feedbackSuccess();
          await Future.delayed(Duration(seconds: 1));
          Get.offAllNamed('/home');
          ShowSnackbar.success(
              'Selamat Kembali $userName', 'Log masuk berjaya!', true);
        }
      });
    }).catchError(
      (err) async {
        ShowSnackbar.error('Kesalahan telah berlaku!', err.toString(), true);
        btnController.error();
        Haptic.feedbackError();
        await Future.delayed(Duration(seconds: 2));
        btnController.reset();
      },
    );
  }

  ///LOG OUT
  void performLogOut() {
    Haptic.feedbackError();
    Get.dialog(
      AlertDialog(
        title: Text('Log Keluar'),
        content: Text('Adakah anda pasti untuk log keluar?'),
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
            child: Text('Batal'),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  Future<void> checkUserData(String uid, String email) async {
    final box = GetStorage();
    final _notifController = Get.put(NotificationController());
    bool internet = await InternetConnectionChecker().hasConnection;

    if (internet == true) {
      await FirebaseDatabase.instance
          .reference()
          .child('Technician')
          .child(uid)
          .once()
          .then((snapshot) async {
        final json = snapshot.value as Map<dynamic, dynamic>;
        final technician = Technician.fromJson(json);
        userUID.value = uid;
        userEmail.value = email;
        userName.value = technician.nama;
        cawangan.value = technician.cawangan;
        jumlahRepair.value = technician.jumlahRepair;
        jumlahKeuntungan.value = technician.jumlahKeuntungan;
        jawatan.value = technician.jawatan;
        photoURL.value = technician.photoURL;
        token = technician.token;
        box.write('userUID', uid);
        box.write('userEmail', email);
        box.write('userName', technician.nama);
        box.write('cawangan', technician.cawangan);
        box.write('jumlahRepair', technician.jumlahRepair);
        box.write('jumlahKeuntungan', technician.jumlahKeuntungan);
        box.write('jawatan', technician.jawatan);
        box.write('photoURL', technician.photoURL);
        box.write('token', technician.token);

        //notification config
        if (box.read<bool>('initNotif') == true) {
          _notifController.subscribedToFCM('socmed');
          if (jawatan.value == 'Founder') {
            print('Notifikasi settlement telah diset kan sekali');
            _notifController.subscribedToFCM('settlement');
          } else {
            _notifController.unsubscribedFromFCM('settlement');
          }
        } else {
          _notifController.unsubscribedFromFCM('socmed');
          if (jawatan.value == 'Founder') {
            print('Notifikasi settlement akan dibatalkan sekali');
            _notifController.unsubscribedFromFCM('settlement');
          } else {
            _notifController.unsubscribedFromFCM('settlement');
          }
        }
        final String deviceToken = await FirebaseMessaging.instance.getToken();
        print('your new device token: $deviceToken');

        if (token != deviceToken) {
          print('tukar token baru: $deviceToken');
          token = deviceToken;
          FirebaseDatabase.instance
              .reference()
              .child('Technician')
              .child(uid)
              .update({'token': deviceToken});
        }
      });

      //check user database
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      final path = join(documentDirectory.path, '${userUID.value}.db');
      bool checkFile = await File(path).exists();
      File file = File(path);

      if (checkFile == false) {
        try {
          final destination = 'database/SQLite/${userUID.value}.db';
          final ref = FirebaseStorage.instance.ref(destination);
          await ref.writeToFile(file);
        } on Exception catch (e) {
          print(e);
        }
      }
    } else {
      ShowSnackbar.error('Gagal untuk menyambung ke rangkaian',
          'Pastikan peranti anda telah disambungkan ke rangkaian', true);

      userUID.value = box.read('uid');
      userEmail.value = box.read('email');
      userName.value = box.read('userName');
      cawangan.value = box.read('cawangan');
      jumlahRepair.value = box.read<int>('jumlahRepair');
      jumlahKeuntungan.value = box.read<int>('jumlahKeuntungan');
      jawatan.value = box.read('jawatan');
      photoURL.value = box.read('photoURL');
      token = box.read('token');
    }
  }
}
