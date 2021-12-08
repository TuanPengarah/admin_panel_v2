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

  void _handleMessage(RemoteMessage message) {
    if (message.data['screen'] != null) {
      Get.toNamed(message.data['screen']);
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
        onTap: (test) => screen == null ? null : Get.toNamed(screen),
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
    // AwesomeNotifications().isNotificationAllowed().then(
    //   (isAllowed) async {
    //     if (!isAllowed) {
    //       if (GetPlatform.isIOS) {
    //         await FirebaseMessaging.instance
    //             .setForegroundNotificationPresentationOptions(
    //           alert: true, // Required to display a heads up notification
    //           badge: true,
    //           sound: true,
    //         );
    //       } else {
    //         Get.dialog(
    //           AlertDialog(
    //             title: Text('Benarkan Notifikasi'),
    //             content: Text(
    //                 'Aplikasi ini akan memaparkan notifikasi. Adakah anda setuju?'),
    //             actions: [
    //               TextButton(
    //                 child: Text(
    //                   'Tidak',
    //                   style: TextStyle(
    //                     color: Colors.amber[900],
    //                   ),
    //                 ),
    //                 onPressed: () {
    //                   Haptic.feedbackError();
    //                   Get.back();
    //                 },
    //               ),
    //               TextButton(
    //                 child: Text(
    //                   'Benarkan',
    //                 ),
    //                 onPressed: () => AwesomeNotifications()
    //                     .requestPermissionToSendNotifications()
    //                     .then(
    //                   (_) {
    //                     Haptic.feedbackSuccess();
    //                     Get.back();
    //                   },
    //                 ),
    //               ),
    //             ],
    //           ),
    //         );
    //       }
    //     }
    //   },
    // );
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
