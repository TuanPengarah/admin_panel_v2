import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:admin_panel/cust_overview/view/model/popupmenu_overview.dart';
import 'package:admin_panel/home/controller/customer_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class OverviewController extends GetxController {
  var currentIndex = 0.obs;
  var isEdit = false.obs;

  final _customerController = Get.find<CustomerController>();

  void popupMenuSelected(IconMenuOverview value, String uid) {
    switch (value) {
      case PopupMenuOverview.edit:
        Haptic.feedbackClick();
        print('edit engage');
        isEdit.value = true;
        break;
      case PopupMenuOverview.delete:
        Haptic.feedbackError();
        Get.dialog(
          AlertDialog(
            title: Text('Amaran!'),
            content: Text(
              'Jika anda membuang pelanggan ini, segala maklumat sejarah baiki dan data peribadi pada pelanggan ini akan dipadam!',
            ),
            actions: [
              TextButton(
                onPressed: () => deleteUserData(uid),
                child: Text(
                  'Padam',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Batal',
                ),
              ),
            ],
          ),
        );
    }
  }

  void saveUserData(
    String uid,
    String nama,
    String phone,
  ) {
    var _firestore = FirebaseFirestore.instance;

    Map<String, dynamic> data = {
      'Nama': nama,
      'No Phone': phone,
    };

    _firestore.collection('customer').doc(uid).update(data);
  }

  void deleteUserData(String uid) async {
    var _firestore = FirebaseFirestore.instance;
    await _firestore
        .collection('customer')
        .doc(uid)
        .collection('repair history')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        _firestore
            .collection('customer')
            .doc(uid)
            .collection('repair history')
            .doc(element.id)
            .delete();
      });
    });

    await _firestore.collection('customer').doc(uid).delete();
    Get.back();
    Get.back();
    ShowSnackbar.success(
        'Selesai!', 'Proses membuang untuk pelanggan ini telah selesai', true);
    Haptic.feedbackSuccess();
    _customerController.getCustomerDetails();
  }

  void addToJobsheet(String nama, String phone, String email, String uid) {
    Haptic.feedbackClick();
    Get.toNamed(MyRoutes.jobsheet, arguments: [true, nama, phone, email, uid]);
  }

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
            ListTile(
                leading: Icon(Icons.content_copy),
                title: Text('Salin ke Clipboard'),
                subtitle: Text('$noFon'),
                onTap: () {
                  Get.back();
                  Clipboard.setData(ClipboardData(text: "$noFon"));
                  ShowSnackbar.notify('Nombor telefon di salin!',
                      '$noFon telah disalin pada Clipboard anda');
                }),
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
