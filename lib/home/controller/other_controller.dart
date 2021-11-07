import 'dart:io';

import 'package:admin_panel/auth/controller/firebaseAuth_controller.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
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

  Future<void> downloadFromFirebase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path =
        join(documentDirectory.path, '${_authController.userUID.value}.db');
    File file = File(path);
    final destination = 'database/SQLite/${_authController.userUID.value}.db';
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      await ref.writeToFile(file);
      ShowSnackbar.success('Muat turun selesai!',
          'Data SQLite anda telah dimuat turun dari Firebase Storage', true);
      Haptic.feedbackSuccess();
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
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    if (result != null) {
      if (result.names.first.toString().contains('.db')) {
        File file = File(result.paths.first);
        Directory documentDirectory = await getApplicationDocumentsDirectory();
        String path =
            join(documentDirectory.path, '${_authController.userUID.value}.db');
        await file.copy(path);
        Haptic.feedbackSuccess();
        ShowSnackbar.success(
            'Berjaya', 'Database telah berjaya di import', true);
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
      Share.shareFiles([path]);
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

      deviceModel.value = web.platform;
    } else {
      deviceModel.value = '--';
    }
  }
}
