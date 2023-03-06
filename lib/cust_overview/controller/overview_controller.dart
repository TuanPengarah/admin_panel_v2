import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:admin_panel/cust_overview/model/popupmenu_overview.dart';
import 'package:admin_panel/home/controller/customer_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class OverviewController extends GetxController {
  var currentIndex = 0.obs;
  var isEdit = false.obs;
  var customerName = ''.obs;
  var noPhone = ''.obs;

  final _customerController = Get.find<CustomerController>();
  final _data = Get.arguments;

  @override
  void onInit() {
    checkEdit();
    super.onInit();
  }

  void checkEdit() {
    customerName.value = _data['Nama'];
    noPhone.value = _data['No Phone'];
  }

  void popupMenuSelected(IconMenuOverview value, String uid, String nama) {
    switch (value) {
      case PopupMenuOverview.edit:
        Haptic.feedbackClick();
        ShowSnackbar.notify('Mod suntingan aktif!',
            'Tekan butang simpan jika anda ingin menyimpan suntingan anda ke server pelanggan');
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
                onPressed: () => deleteUserData(uid, nama),
                child: Text(
                  'Padam',
                  style: TextStyle(color: Colors.amber[900]),
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

  void editUsername() {
    var errName = false.obs;
    final namaEdit = TextEditingController();
    namaEdit.text = customerName.value;
    Get.dialog(
      AlertDialog(
        title: Text('Sunting Nama Pelanggan'),
        content: Obx(
          () => TextField(
            controller: namaEdit,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
                errorText: errName.value == true
                    ? 'Sila masukkan nama pelanggan'
                    : null),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Batal',
            ),
          ),
          TextButton(
            onPressed: () {
              if (namaEdit.text.isEmpty) {
                errName.value = true;
              } else {
                errName.value = false;
                customerName.value = namaEdit.text;
                Get.back();
              }
            },
            child: Text(
              'Simpan',
            ),
          ),
        ],
      ),
    );
  }

  void editPhone() {
    var errPhone = false.obs;
    final phoneEdit = TextEditingController();
    phoneEdit.text = noPhone.value;
    Get.dialog(
      AlertDialog(
        title: Text('Sunting Nombor Panggilan'),
        content: Obx(
          () => TextField(
            controller: phoneEdit,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                errorText: errPhone.value == true
                    ? 'Sila masukkan nombor panggilan'
                    : null),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Batal',
            ),
          ),
          TextButton(
            onPressed: () {
              if (phoneEdit.text.isEmpty) {
                errPhone.value = true;
              } else {
                errPhone.value = false;
                noPhone.value = phoneEdit.text;
                Get.back();
              }
            },
            child: Text(
              'Simpan',
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> saveUserData(String uid) async {
    bool result = false;
    Haptic.feedbackSuccess();
    if (customerName != _data['Nama'] || noPhone != _data['No Phone']) {
      await Get.dialog(AlertDialog(
        title: Text('Simpan suntingan anda?'),
        content: Text(
            'Adakah anda pasti untuk menyimpan segala suntingan anda ke server pelanggan?'),
        actions: [
          TextButton(
            onPressed: () {
              isEdit.value = true;
              result = false;
              Get.back();
            },
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              var _firestore = FirebaseFirestore.instance;

              Map<String, dynamic> data = {
                'Nama': customerName.value,
                'No Phone': noPhone.value,
              };

              await _firestore
                  .collection('customer')
                  .doc(uid)
                  .update(data)
                  .then((value) {
                result = true;
                Get.back();
                ShowSnackbar.success('Operasi Selesai!',
                    'Data pelanggan anda telah di kemas kini', false);
                Haptic.feedbackSuccess();
                isEdit.value = false;
                _customerController.getCustomerDetails();
              }).catchError((err) {
                Get.back();
                isEdit.value = false;
                Haptic.feedbackError();
                ShowSnackbar.error('Opps!',
                    'Gagal untuk mengemaskini data pelanggan: $err', false);
              });
            },
            child: Text('Simpan'),
          ),
        ],
      ));
    } else {
      isEdit.value = false;
    }
    return result;
  }

  void deleteUserData(String uid, String name) async {
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
    ShowSnackbar.success('Selesai!', 'Pelanggan $name telah dipadam', false);
    Haptic.feedbackSuccess();
    _customerController.getCustomerDetails();
  }

  void addToJobsheet(String nama, String phone, String email, String uid) {
    Haptic.feedbackClick();
    Get.toNamed(MyRoutes.jobsheet, arguments: [true, nama, phone, email, uid]);
  }

  void showSheet(String noFon, String nama) {
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
                onTap: () => launchWhatsapp(noFon, nama)),
            ListTile(
                leading: Icon(Icons.content_copy),
                title: Text('Salin ke Clipboard'),
                subtitle: Text('$noFon'),
                onTap: () {
                  Get.back();
                  Clipboard.setData(ClipboardData(text: "$noFon"));
                  ShowSnackbar.notify('Nombor telefon di salin!',
                      '$noFon telah disalin pada Clipboard peranti anda');
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
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
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
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      Get.back();
      ShowSnackbar.error(
          'Kesalahan Telah berlaku', 'Email tidak dapat diakses', false);
    }
  }

  void launchSms(String noFon) async {
    final url = "sms:$noFon";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      Get.back();
      ShowSnackbar.error(
          'Kesalahan Telah berlaku', 'SMS tidak dapat diakses', false);
    }
  }

  void launchWhatsapp(String noFon, String nama) async {
    String phone = noFon.contains('+6') ? noFon : '+6$noFon';
    final url = GetPlatform.isAndroid
        ? "whatsapp://send?phone=$phone&text=Salam $nama!"
        : "https://wa.me/$phone/?text=Salam $nama!";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      Get.back();
      ShowSnackbar.error(
          'Kesalahan Telah berlaku', 'WhatsApp tidak dapat diakses', false);
    }
  }
}
