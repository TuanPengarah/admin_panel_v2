import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AuthController extends GetxController {
  final _auth = FirebaseAuth.instance;

  ///LOGIN
  void performLogin(String email, String password,
      RoundedLoadingButtonController btnController) async {
    Haptic.feedbackClick();
    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      Get.showSnackbar(
        GetBar(
          title: 'Selamat Kembali!',
          message: 'Log masuk berjaya',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
      btnController.success();
      Haptic.feedbackSuccess();
      await Future.delayed(Duration(seconds: 2));
      Get.offAllNamed('/home');
    }).catchError(
      (err) async {
        Get.showSnackbar(
          GetBar(
            title: 'Kesalahan Telah berlaku',
            message: err.toString(),
            backgroundColor: Colors.amber[900],
            duration: Duration(seconds: 5),
          ),
        );
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
      Get.offAllNamed('/login');
      Get.showSnackbar(
        GetBar(
          title: 'Log Keluar Berjaya!',
          message: 'Anda telah di log keluar',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    }).catchError((err) {
      Haptic.feedbackError();
      Get.showSnackbar(
        GetBar(
          title: 'Kesalahan Telah berlaku',
          message: err.toString(),
          backgroundColor: Colors.amber[900],
          duration: Duration(seconds: 5),
        ),
      );
    });
  }
}
