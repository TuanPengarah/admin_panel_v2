import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthController extends GetxController {
  final _auth = FirebaseAuth.instance;

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
      ShowSnackbar.success('Selamat Kembali', 'Log masuk berjaya!', true);

      btnController.success();
      Haptic.feedbackSuccess();
      await Future.delayed(Duration(seconds: 2));
      Get.offAllNamed('/home');
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
      Get.offAllNamed('/login');
      ShowSnackbar.success('Log Keluar Berjaya', 'Anda telah di log keluar!', true);
    }).catchError((err) {
      Haptic.feedbackError();
      ShowSnackbar.error('Kesalahan telah berlaku', err.toString(), true);
    });
  }
}
