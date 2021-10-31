import 'dart:io';

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
      File file = File(result.paths.first);
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentDirectory.path, 'af-fix.db');
      await file.copy(path);
      Haptic.feedbackSuccess();
      ShowSnackbar.success(
          'Berjaya', 'Database telah berjaya di import', false);
    } else {
      Haptic.feedbackError();
    }
  }

  void saveDBToDevice() async {
    Get.back();
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'af-fix.db');
    Share.shareFiles([path]);
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
