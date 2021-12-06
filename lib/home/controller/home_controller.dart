import 'dart:math';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quick_actions/quick_actions.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;
  var totalMysid = 0.obs;
  final QuickActions quickActions = const QuickActions();
  final box = GetStorage();

  @override
  void onReady() {
    currentIndex.value = box.read<int>('nav') ?? 0;
    createQuickstep();
    notificationPermision();
    firebaseMessaging();
    super.onReady();
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['screen'] != null) {
      Get.toNamed(message.data['screen']);
    }
  }

  void firebaseMessaging() async {
    int id = Random().nextInt(999);
    FirebaseMessaging.instance.subscribeToTopic('adminPanel');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (GetPlatform.isIOS) {
        ShowSnackbar.notify(
          message.notification.title,
          message.notification.body,
        );
      } else if (GetPlatform.isAndroid) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id,
            channelKey: 'fcm',
            title: message.notification.title,
            body: message.notification.body,
            notificationLayout: NotificationLayout.BigText,
          ),
          actionButtons: [
            NotificationActionButton(
              key: 'MARK_DONE',
              label: 'Okay',
              buttonType: ActionButtonType.KeepOnTop,
            ),
          ],
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  void notificationPermision() {
    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed) {
          if (GetPlatform.isIOS) {
            await FirebaseMessaging.instance
                .setForegroundNotificationPresentationOptions(
              alert: true, // Required to display a heads up notification
              badge: true,
              sound: true,
            );
          } else {
            Get.dialog(
              AlertDialog(
                title: Text('Benarkan Notifikasi'),
                content: Text(
                    'Aplikasi ini akan memaparkan notifikasi. Adakah anda setuju?'),
                actions: [
                  TextButton(
                    child: Text(
                      'Tidak',
                      style: TextStyle(
                        color: Colors.amber[900],
                      ),
                    ),
                    onPressed: () {
                      Haptic.feedbackError();
                      Get.back();
                    },
                  ),
                  TextButton(
                    child: Text(
                      'Benarkan',
                    ),
                    onPressed: () => AwesomeNotifications()
                        .requestPermissionToSendNotifications()
                        .then(
                      (_) {
                        Haptic.feedbackSuccess();
                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        }
      },
    );
  }

  void createQuickstep() {
    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
        type: 'actions_jobsheet',
        localizedTitle: 'Tambah Jobsheet',
        icon: 'add_jobsheet',
      ),
      const ShortcutItem(
        type: 'actions_cashFlow',
        localizedTitle: 'Cash Flow',
        icon: 'cash_flow',
      ),
      const ShortcutItem(
        type: 'actions_pos',
        localizedTitle: 'POS',
        icon: 'pos',
      ),
      const ShortcutItem(
        type: 'actions_priceList',
        localizedTitle: 'Senarai Harga',
        icon: 'price_list',
      ),
    ]);

    quickActions.initialize((type) {
      if (type == 'actions_jobsheet') {
        Get.toNamed(MyRoutes.jobsheet, arguments: [false, '', '', '', '']);
      } else if (type == 'actions_cashFlow') {
        Get.toNamed(MyRoutes.cashFlow);
      } else if (type == 'actions_priceList') {
        Get.toNamed(MyRoutes.pricelist);
      } else if (type == 'actions_pos') {
        Get.toNamed(MyRoutes.bills);
      }
    });
  }

  void navTap(int index) {
    Haptic.feedbackClick();
    currentIndex.value = index;
    box.write('nav', index);
  }
}
