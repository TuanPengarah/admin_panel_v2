import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class NotificationController extends GetxController {
  int _createID() => Random().nextInt(999);
  var groupValue = false.obs;
  final box = GetStorage();

  @override
  onInit() {
    getValue();
    print('init notification');
    super.onInit();
  }

  Future<void> getValue() async {
    groupValue.value = box.read<bool>('initNotif') ?? false;
  }

  Future<void> socialMediaNotif() async {
    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: _createID(),
        channelKey: 'socmed',
        title: 'Tambah siaran pada media sosial!',
        body:
            'Sudahkah anda buat post pada media sosial? Jika belum, sila buat sekarang!',
        notificationLayout: NotificationLayout.BigText,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'MARK_DONE',
          label: 'Dah Buat',
          buttonType: ActionButtonType.KeepOnTop,
        ),
      ],
      schedule: NotificationCalendar(
        repeats: true,
        timeZone: localTimeZone,
        hour: 12,
        minute: 30,
        second: 0,
        millisecond: 0,
      ),
    );
  }

  Future<void> cancelAllSchedule() async {
    await AwesomeNotifications()
        .cancelAllSchedules()
        .then((value) => print('Schedule Cancel'));
  }
}
