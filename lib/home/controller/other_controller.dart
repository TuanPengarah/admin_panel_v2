import 'dart:io';
import 'package:admin_panel/auth/controller/firebaseauth_controller.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart';

class OtherController extends GetxController {
  var deviceModel = '--'.obs;
  final _authController = Get.find<AuthController>();
  @override
  void onInit() {
    getDeviceModel();
    super.onInit();
  }

  // Future<void> deletedSQLite() async {
  //   Directory documentDirectory = await getApplicationDocumentsDirectory();

  //   String path =
  //       join(documentDirectory.path, '${_authController.userUID.value}.db');
  //   File file = File(path);
  //   bool checkFile = await file.exists();
  //   final db = await DatabaseHelper.instance.database;

  //   if (checkFile == true) {
  //     await file.delete();

  //     db.close();
  //     await DatabaseHelper.instance.initDatabase();
  //     Get.back();
  //     if (GetPlatform.isAndroid) {
  //       ShowSnackbar.success(
  //           'Operasi selesai!',
  //           'Fail SQLite telah berjaya di buang, aplikasi ini akan mula semula...',
  //           true);

  //       await Future.delayed(Duration(seconds: 3));
  //       Restart.restartApp();
  //     } else {
  //       ShowSnackbar.success(
  //           'Operasi selesai!',
  //           'Fail SQLite telah berjaya di buang, Sila \'Restart\' aplikasi ini!',
  //           true);
  //       await Future.delayed(Duration(seconds: 3));
  //       exit(0);
  //     }
  //   } else {
  //     Get.back();
  //     ShowSnackbar.error(
  //         'Kesalahan telah berlaku', 'Fail SQLite tidak dapat ditemui', true);
  //   }
  // }

  Future<void> downloadFromFirebase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String path =
        join(documentDirectory.path, '${_authController.userUID.value}.db');
    File file = File(path);
    debugPrint(file.path.toString());
    final destination = 'database/SQLite/${_authController.userUID.value}.db';
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      await ref.writeToFile(file);
      ShowSnackbar.success(
          'Muat turun selesai!',
          'Data SQLite anda telah dimuat turun dari Firebase Storage, Aplikasi ini akan ditutup! Sila mula semula untuk melihat perubahan!',
          true);
      Haptic.feedbackSuccess();
      await Future.delayed(const Duration(seconds: 3));
      if (GetPlatform.isAndroid) {
        Restart.restartApp();
      } else {
        exit(0);
      }
    } on FirebaseException catch (e) {
      ShowSnackbar.error('Kesalahan telah berlaku', e.toString(), true);
      Haptic.feedbackError();
    }
  }

  Future<void> uploadToFirebase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path =
        join(documentDirectory.path, '${_authController.userUID.value}.db');
    File file = File(path);
    bool checkFile = await File(path).exists();
    if (checkFile == true) {
      try {
        final destination =
            'database/SQLite/${_authController.userUID.value}.db';
        final ref = FirebaseStorage.instance.ref(destination);
        await ref.putFile(file);
        ShowSnackbar.success('Muat naik selesai!',
            'Data SQLite anda telah dimuat naik ke Firebase Storage', true);
        Haptic.feedbackSuccess();
      } on FirebaseException catch (e) {
        ShowSnackbar.error('Kesalahan telah berlaku', e.toString(), true);
        Haptic.feedbackError();
      }
    } else {
      ShowSnackbar.error(
          'Kesalahan telah berlaku', 'Fail SQLite tidak dapat ditemui', true);
      Haptic.feedbackError();
    }
  }

  void getFromDevices() async {
    Get.back();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    if (result != null) {
      if (result.names.first.toString().contains('.db')) {
        File file = File(result.paths.first.toString());
        Directory documentDirectory = await getApplicationDocumentsDirectory();
        String path =
            join(documentDirectory.path, '${_authController.userUID.value}.db');
        await file.copy(path);
        Haptic.feedbackSuccess();
        ShowSnackbar.success(
            'Berjaya',
            'Database telah berjaya di import, Aplikasi ini akan ditutup! Sila mula semula untuk melihat perubahan!',
            true);
        await Future.delayed(const Duration(seconds: 3));
        if (GetPlatform.isAndroid) {
          Restart.restartApp();
        } else {
          exit(0);
        }
      } else {
        Haptic.feedbackError();
        ShowSnackbar.error(
            'Salah fail!',
            'Fail yang anda pilih adalah salah! Pastikan format fail databasa adalah <user-id>.db',
            true);
      }
    } else {
      Haptic.feedbackError();
    }
  }

  void saveDBToDevice() async {
    Get.back();

    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path =
        join(documentDirectory.path, '${_authController.userUID.value}.db');
    bool file = await File(path).exists();
    if (file == true) {
      Share.shareXFiles([XFile(path)]);
    } else {
      Haptic.feedbackError();
      ShowSnackbar.error(
          'Kesalahan telah berlaku!', 'Fail SQLite tidak dapat ditemui', true);
    }
  }

  void getDeviceModel() async {
    DeviceInfoPlugin info = DeviceInfoPlugin();
    if (GetPlatform.isAndroid) {
      AndroidDeviceInfo android = await info.androidInfo;
      deviceModel.value = android.model;
    } else if (GetPlatform.isIOS) {
      IosDeviceInfo ios = await info.iosInfo;

      deviceModel.value = '${ios.utsname.machine}';
    } else if (GetPlatform.isWeb) {
      WebBrowserInfo web = await info.webBrowserInfo;

      deviceModel.value = web.platform.toString();
    } else {
      deviceModel.value = '--';
    }
  }
}
