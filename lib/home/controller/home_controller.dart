import 'dart:async';
import 'package:admin_panel/API/sqlite.dart';
import 'package:admin_panel/chat/model/chat_model.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/notification/controller/notification_controller.dart';
import 'package:admin_panel/notification/model/notification_model.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quick_actions/quick_actions.dart';
import '../../auth/controller/firebaseAuth_controller.dart';
import '../../config/snackbar.dart';

class HomeController extends GetxController {
  final _notifController = Get.find<NotificationController>();
  final _authController = Get.find<AuthController>();
  var currentIndex = 0.obs;
  var totalMysid = 0.obs;
  final QuickActions quickActions = const QuickActions();
  final box = GetStorage();
  bool isChat = false;

  @override
  void onReady() {
    if (!GetPlatform.isWeb) {
      createQuickstep();
    }
    currentIndex.value = box.read<int>('nav') ?? 0;
    notificationPermision();
    firebaseMessaging();
    streamOnApp();
    super.onReady();
  }

  @override
  void onClose() {
    streamOnApp().cancel();
    super.onClose();
  }

  void _handleMessage(RemoteMessage message) async {
    var screen = message.data['screen'];
    if (screen == null) {
      return null;
    } else if (screen == '/chat') {
      await Future.delayed(Duration(seconds: 2));

      ChatModel chitChat = new ChatModel(
        content: message.notification.body,
        date: message.sentTime.toString(),
        whoChat: 1,
        idUser: message.data['uid'],
      );
      Get.dialog(AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
          ],
        ),
      ));
      await Future.delayed(Duration(seconds: 4));
      await DatabaseHelper.instance.addChat(chitChat);
      await Future.delayed(Duration(seconds: 2));
      Get.back();
      Get.toNamed(screen, arguments: {
        'name': message.data['name'],
        'photoURL': message.data['photoURL1'],
        'photoURL1': message.data['photoURL'],
        'token': message.data['userToken'],
        'userToken': message.data['token'],
        'uid': message.data['uid'],
      }, parameters: {
        'id': message.data['uid']
      });
    } else {
      Get.toNamed(screen);
    }
    if (message.notification != null) {
      NotificationsModel notif = new NotificationsModel(
        title: message.notification.title,
        body: message.notification.body,
        tarikh: message.sentTime.toString(),
      );
      print('waiting for 5 seconds to init sqlite');
      await Future.delayed(Duration(seconds: 5));
      print('inserting on notification history...');
      await DatabaseHelper.instance.addNotificationHistory(notif);
    }
  }

  StreamSubscription<RemoteMessage> streamOnApp() {
    return FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('masej masyuk');
      NotificationsModel notif = new NotificationsModel(
        title: message.notification.title,
        body: message.notification.body,
        tarikh: DateTime.now().toString(),
      );
      ChatModel chitChat = new ChatModel(
        content: notif.body,
        date: DateTime.now().toString(),
        whoChat: 1,
        idUser: message.data['uid'],
      );

      String screen = message.data['screen'];
      DatabaseHelper.instance.addNotificationHistory(notif);

      if (screen == '/chat' && isChat == false) {
        await DatabaseHelper.instance.addChat(chitChat);
        ShowSnackbar.notify(
          message.notification.title,
          message.notification.body,
          onTap: (test) {
            if (screen == null) {
              return null;
            } else if (screen == '/chat') {
              Get.closeCurrentSnackbar();
              Get.toNamed(screen, arguments: {
                'name': message.data['name'],
                'photoURL': message.data['photoURL1'],
                'photoURL1': message.data['photoURL'],
                'token': message.data['userToken'],
                'userToken': message.data['token'],
                'uid': message.data['uid'],
              }, parameters: {
                'id': message.data['uid']
              });
            } else {
              Get.closeCurrentSnackbar();
              Get.toNamed(screen);
            }
          },
        );
      } else if (screen == '/chat' && isChat == true) {
        await DatabaseHelper.instance.addChat(chitChat);
      } else {
        ShowSnackbar.notify(
            message.notification.title, message.notification.body);
      }
    });
  }

  void firebaseMessaging() async {
    debugPrint('initiate firebase Messaging');
    if (!GetPlatform.isWeb) {
      FirebaseMessaging.instance.subscribeToTopic('adminPanel');
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    if (!GetPlatform.isWeb) {
      //notification config
      if (box.read<bool>('initNotif') == true) {
        _notifController.subscribedToFCM('socmed');
        if (_authController.jawatan.value == 'Founder') {
          print('Notifikasi settlement telah diset kan sekali');
          _notifController.subscribedToFCM('settlement');
        } else {
          _notifController.unsubscribedFromFCM('settlement');
        }
      } else {
        _notifController.unsubscribedFromFCM('socmed');
        if (_authController.jawatan.value == 'Founder') {
          print('Notifikasi settlement akan dibatalkan sekali');
          _notifController.unsubscribedFromFCM('settlement');
        } else {
          _notifController.unsubscribedFromFCM('settlement');
        }
      }
    }
  }

  void notificationPermision() async {
    if (GetPlatform.isWeb == false) {
      AwesomeNotifications().initialize(
        'resource://drawable/res_notification_app_icon',
        [
          NotificationChannel(
            channelKey: 'fcm',
            channelName: 'Firebase Cloud Messaging',
            channelDescription:
                'Pemberitahuan daripada Firebase Cloud Messaging',
            defaultColor: Colors.blue,
            importance: NotificationImportance.High,
          ),
        ],
      );
    }
    if (GetPlatform.isIOS || GetPlatform.isWeb) {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint('User granted permission: ${settings.authorizationStatus}');
    }
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
