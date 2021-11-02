import 'dart:io';

import 'package:admin_panel/auth/controller/firebaseAuth_controller.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
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
            'Berjaya', 'Database telah berjaya di import', false);
      } else {
        Haptic.feedbackError();
        ShowSnackbar.error(
            'Salah fail!',
            'Fail yang anda pilih adalah salah! Pastikan format fail databasa adalah <user-id>.db',
            false);
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
          'Kesalahan telah berlaku!', 'Fail SQLite tidak dapat ditemui', false);
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
