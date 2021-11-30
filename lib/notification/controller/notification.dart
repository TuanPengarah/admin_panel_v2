import 'dart:math';
import 'package:admin_panel/auth/controller/firebaseAuth_controller.dart';
import 'package:admin_panel/cash_flow/controller/cashflow_controller.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class NotificationController extends GetxController {
  final _authController = Get.find<AuthController>();
  final _cashFlowController = Get.put(CashFlowController());
  int _createID() => Random().nextInt(999);
  var groupValue = false.obs;
  final box = GetStorage();

  @override
  onInit() {
    getValue();
    super.onInit();
  }

  Future<void> subscribedToFCM(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  Future<void> unsubscribedFromFCM(String topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

  Future<void> getValue() async =>
      groupValue.value = box.read<bool>('initNotif') ?? false;

  Future<void> socialMediaNotif() async {
    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: _createID(),
        channelKey: 'socmed',
        title: 'Assalamualaikum ${_authController.userName.value}!',
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
        allowWhileIdle: true,
        repeats: true,
        timeZone: localTimeZone,
        hour: 12,
        minute: 30,
        second: 0,
        millisecond: 0,
      ),
    );
  }

  Future<void> settlementReport() async {
    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: _createID(),
        channelKey: 'settlement',
        title: 'Laporan untuk hari ini!',
        body:
            'Hasil kesularahan baki akaun semasa anda adalah RM${_cashFlowController.total.value}',
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'OKAY',
          label: 'Okay',
          buttonType: ActionButtonType.KeepOnTop,
        ),
      ],
      schedule: NotificationCalendar(
        allowWhileIdle: true,
        timeZone: localTimeZone,
        repeats: true,
        hour: 22,
        minute: 0,
        second: 0,
        millisecond: 0,
      ),
    );
  }

  Future<void> socialMediaNotifTest() async {
    // String localTimeZone =
    //     await AwesomeNotifications().getLocalTimeZoneIdentifier();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: _createID(),
        channelKey: 'fcm',
        title: 'Assalamualaikum ${_authController.userName.value}!',
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
      schedule: NotificationInterval(
        interval: 10,
      ),
    );
  }

  Future<void> cancelAllSchedule() async {
    await AwesomeNotifications()
        .cancelAllSchedules()
        .then((value) => print('Schedule Cancel'));
  }
}
