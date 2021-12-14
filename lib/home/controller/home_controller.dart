import 'package:admin_panel/API/sqlite.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:admin_panel/notification/model/notification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
    if (!GetPlatform.isWeb) {
      currentIndex.value = box.read<int>('nav') ?? 0;
      createQuickstep();
    }
    notificationPermision();
    firebaseMessaging();
    super.onReady();
  }

  void _handleMessage(RemoteMessage message) async {
    var screen = message.data['screen'];
    if (screen == null) {
      return null;
    } else if (screen == '/chat') {
      Get.toNamed(message.data['screen'], arguments: {
        'name': message.data['name'],
        'photoURL': message.data['photoURL'],
      }, parameters: {
        'id': message.data['uid']
      });
    } else {
      Get.toNamed(screen);
    }
    if (message.notification != null) {
      NotificationModel notif = new NotificationModel(
        title: message.notification.title,
        body: message.notification.body,
        tarikh: DateTime.now().toString(),
      );
      print('waiting for 5 seconds to init sqlite');
      await Future.delayed(Duration(seconds: 5));
      print('inserting on notification history...');
      await DatabaseHelper.instance.addNotificationHistory(notif);
    }
  }

  void firebaseMessaging() async {
    if (!GetPlatform.isWeb) {
      FirebaseMessaging.instance.subscribeToTopic('adminPanel');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationModel notif = new NotificationModel(
        title: message.notification.title,
        body: message.notification.body,
        tarikh: DateTime.now().toString(),
      );
      String screen = message.data['screen'];
      DatabaseHelper.instance.addNotificationHistory(notif);
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
              'photoURL': message.data['photoURL'],
            }, parameters: {
              'id': message.data['uid']
            });
          } else {
            Get.closeCurrentSnackbar();
            Get.toNamed(screen);
          }
        },
      );
    });
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  void notificationPermision() async {
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

      print('User granted permission: ${settings.authorizationStatus}');
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
    if (!GetPlatform.isWeb) {
      box.write('nav', index);
    }
  }
}
