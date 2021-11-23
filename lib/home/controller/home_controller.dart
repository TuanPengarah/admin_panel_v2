import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_actions/quick_actions.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;
  var totalMysid = 0.obs;
  final QuickActions quickActions = const QuickActions();

  @override
  void onReady() {
    createQuickstep();
    notificationPermision();
    super.onReady();
  }

  void notificationPermision() {
    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          if (GetPlatform.isIOS) {
            print('notif ios');
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
    currentIndex.value = index;
  }

  void showBottomJosheet() async {
    Haptic.feedbackClick();
    await Get.bottomSheet(
      Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Buat Jobsheet baru'),
              onTap: () {
                Get.back();
                Get.toNamed(MyRoutes.jobsheet,
                    arguments: [false, '', '', '', '']);
              },
            ),
            ListTile(
                leading: Icon(Icons.assignment_ind),
                title: Text('Buat Jobsheet dengan pelanggan sedia ada'),
                onTap: () {
                  Get.back();
                  currentIndex.value = 1;
                  ShowSnackbar.notify('Pilih Pelanggan',
                      'Sila pilih pelanggan dan tekan tambah Jobsheet');
                }),
          ],
        ),
      ),
      enterBottomSheetDuration: Duration(milliseconds: 150),
      exitBottomSheetDuration: Duration(milliseconds: 150),
    );
  }
}
