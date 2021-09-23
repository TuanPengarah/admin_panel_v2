import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';

class OtherController extends GetxController {
  var deviceModel = '--'.obs;

  @override
  void onInit() {
    getDeviceModel();
    super.onInit();
  }

  void getDeviceModel() async {
    DeviceInfoPlugin info = DeviceInfoPlugin();
    if (GetPlatform.isAndroid) {
      AndroidDeviceInfo android = await info.androidInfo;
      deviceModel.value = android.model;
    } else if (GetPlatform.isIOS) {
      IosDeviceInfo ios = await info.iosInfo;
      deviceModel.value = ios.model;
    } else if (GetPlatform.isWeb) {
      WebBrowserInfo web = await info.webBrowserInfo;

      deviceModel.value = web.platform;
    } else {
      deviceModel.value = '--';
    }
  }
}
