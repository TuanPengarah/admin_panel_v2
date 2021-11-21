import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class NotificationController extends GetxController {
  int _createID() => DateTime.now().millisecond;

  Future<void> testNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: _createID(),
          channelKey: 'socmed',
          title: 'Tambah siaran pada media sosial!',
          body:
              'Sudahkah anda buat post pada media sosial? Jika belum, sila buat sekarang!'),
    );
  }
}
