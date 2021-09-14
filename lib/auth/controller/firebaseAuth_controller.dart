import 'package:admin_panel/auth/model/technician_model.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AuthController extends GetxController {
  final _auth = FirebaseAuth.instance;
  String userUID = '';
  String userEmail = '';
  String userName = '';
  String cawangan = '';
  var jumlahRepair = 0.obs;
  var jumlahKeuntungan = 0.obs;

  @override
  void onReady() {
    final user = _auth.currentUser;
    checkUserData(user.uid, user.email);
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
          ShowSnackbar.success('Selamat Kembali', 'Log masuk berjaya!', true);
          btnController.success();
          Haptic.feedbackSuccess();
          await Future.delayed(Duration(seconds: 2));
          Get.offAllNamed('/home');
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
    _auth.signOut().then((value) {
      Get.offAllNamed('/auth');
      ShowSnackbar.success(
          'Log Keluar Berjaya', 'Anda telah di log keluar!', true);
    }).catchError((err) {
      Haptic.feedbackError();
      ShowSnackbar.error('Kesalahan telah berlaku', err.toString(), true);
    });
  }

  Future<void> checkUserData(String uid, String email) async {
    await FirebaseDatabase.instance
        .reference()
        .child('Technician')
        .child(uid)
        .once()
        .then((snapshot) {
      final json = snapshot.value as Map<dynamic, dynamic>;
      final technician = Technician.fromJson(json);
      userUID = uid;
      userEmail = email;
      userName = technician.nama;
      cawangan = technician.cawangan;
      jumlahRepair.value = technician.jumlahRepair;
      jumlahKeuntungan.value = technician.jumlahKeuntungan;
    });
  }
}