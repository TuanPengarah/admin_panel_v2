import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class OverviewController extends GetxController {
  var currentIndex = 0.obs;

  void showSheet(String noFon) {
    Haptic.feedbackClick();
    Get.bottomSheet(
      Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
                leading: Icon(Icons.phone),
                title: Text('Hubungi'),
                subtitle: Text('$noFon'),
                onTap: () => launchCaller(noFon)),
            ListTile(
                leading: Icon(Icons.textsms),
                title: Text('SMS'),
                subtitle: Text('$noFon'),
                onTap: () => launchSms(noFon)),
            ListTile(
                leading: Icon(Icons.chat_bubble),
                title: Text('WhatsApp'),
                subtitle: Text('$noFon'),
                onTap: () => launchWhatsapp(noFon)),
          ],
        ),
      ),
    );
  }

  void copyUID(String uid) {
    Clipboard.setData(ClipboardData(text: "$uid"));
    ShowSnackbar.notify(
        'Pengguna ID di salin!', '$uid telah disalin pada Clipboard anda');
  }

  void launchCaller(String noFon) async {
    final url = "tel:$noFon";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.back();
      ShowSnackbar.error('Kesalahan Telah berlaku',
          'Nombor telefon tidak dapat diakses', false);
    }
  }

  void launchEmail(String email, String nama) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: '$email',
      query: 'subject=Pemberitahuan daripada Af-Fix&body=Assalamualaikum $nama',
    );
    var url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.back();
      ShowSnackbar.error(
          'Kesalahan Telah berlaku', 'Email tidak dapat diakses', false);
    }
  }

  void launchSms(String noFon) async {
    final url = "sms:$noFon";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.back();
      ShowSnackbar.error(
          'Kesalahan Telah berlaku', 'SMS tidak dapat diakses', false);
    }
  }

  void launchWhatsapp(String noFon) async {
    final url =
        noFon.contains('+6') ? 'https://wa.me/$noFon' : "https://wa.me/6$noFon";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.back();
      ShowSnackbar.error(
          'Kesalahan Telah berlaku', 'WhatsApp tidak dapat diakses', false);
    }
  }
}
