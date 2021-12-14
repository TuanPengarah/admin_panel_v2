import 'package:admin_panel/API/notif_fcm.dart';
import 'package:admin_panel/auth/controller/firebaseAuth_controller.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:admin_panel/notification/controller/notification_controller.dart';
import 'package:admin_panel/notification/widget/radio_notif.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/haptic_feedback.dart';

class NotificationSettingView extends GetView<NotificationController> {
  final _authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peringatan media sosial'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: Icon(
                Icons.notification_important,
                color: Colors.grey,
                size: 180,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Aktifkan notifikasi untuk memberitahu tentang mengemaskini siaran pada media sosial!',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Obx(() => RadioTile(
                  label: 'Aktifkan',
                  value: true,
                  groupValue: controller.groupValue.value,
                  onChanged: (bool newValue) {
                    controller.groupValue.value = newValue;
                    controller.box.write('initNotif', true);
                    Haptic.feedbackSuccess();
                    controller.subscribedToFCM('socmed');
                    if (_authController.jawatan.value == 'Founder') {
                      print('Notifikasi settlement telah diset kan sekali');
                      controller.subscribedToFCM('settlement');
                    }
                  },
                )),
            Obx(() => RadioTile(
                  label: 'Tutup Notifikasi',
                  value: false,
                  groupValue: controller.groupValue.value,
                  onChanged: (bool newValue) {
                    controller.groupValue.value = newValue;
                    controller.box.write('initNotif', false);
                    Haptic.feedbackError();
                    controller.unsubscribedFromFCM('socmed');
                    if (_authController.jawatan.value == 'Founder') {
                      print('Notifikasi settlement akan dibatalkan sekali');
                      controller.unsubscribedFromFCM('settlement');
                    }
                  },
                )),
            SizedBox(height: 30),
            TextButton(
              onPressed: () async {
                print(_authController.token);
                Haptic.feedbackClick();
                ShowSnackbar.notify(
                  'Notifikasi telah diset!',
                  'Notifikasi akan berbunyi dalam 10 saat dari sekarang',
                );
                await Future.delayed(Duration(seconds: 10));
                NotifFCM()
                    .postData(
                      'Percubaan Notifikasi',
                      'Ini adalah mesej percubaan!',
                      // token:
                      //     'eXYkBPTmQhSoEUU4Svgp31:APA91bHdGWie68TyUM2odNjCPOSNZXzwQqWXu2-n_j8ZJIOG16r96CfLqcqIV0Qg6Gf0ntK4ZoJ1xGW6eNWPnfKQ4evPdhbE5ryNfGXd_2qG_FFFkG14y9nEzQEtIDyXJr0BH3f1ucUN',
                      // isChat: true,
                      // uid: 'OzyFRxdKzcVGOiuKM93FGUqicHu1',
                      // photoURL:
                      //     'https://firebasestorage.googleapis.com/v0/b/af-fix-database.appspot.com/o/technicians%2FphotoURL%2Fakid.jpg?alt=media&token=0c585605-d795-4c06-9b45-d709abd2d4f4',
                      // name: 'Akid Fikri Azhar',
                    )
                    .then((value) => print(value.statusText));
              },
              child: Text('Cuba Notifikasi Peranti'),
            ),
          ],
        ),
      ),
    );
  }
}
