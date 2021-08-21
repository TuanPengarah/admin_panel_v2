import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      ShowSnackbar.success('Selamat Kembali', 'Log masuk berjaya!');
      btnController.success();
      Haptic.feedbackSuccess();
      await Future.delayed(Duration(seconds: 2));
      Get.offAllNamed('/home');
    }).catchError(
      (err) async {
        ShowSnackbar.error('Kesalahan telah berlaku!', err.toString());
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
      ShowSnackbar.success('Log Keluar Berjaya', 'Anda telah di log keluar!');
    }).catchError((err) {
      Haptic.feedbackError();
      ShowSnackbar.error('Kesalahan telah berlaku', err.toString());
    });
  }
}
