import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:admin_panel/home/model/popupmenu_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerController extends GetxController {
  var isSearch = false.obs;
  var status = ''.obs;
  var descending = false.obs;
  String orderBy = 'Nama';
  final _firestore = FirebaseFirestore.instance.collection('customer');
  List customerList = [];
  List getFromFirestore = [];
  var customerListRead = ''.obs;
  String currentlySelected = '';
  final box = GetStorage();
  Future? getCust;

  @override
  void onInit() {
    getCust = initSorting(box.read('sortCustomer') ?? 'Mengikut abjad A-Z');
    super.onInit();
  }

  Future<void> initSorting(String value) async {
    debugPrint('sorting...');
    switch (value) {
      case 'Mengikut abjad A-Z':
        descending.value = false;
        currentlySelected = value;
        Haptic.feedbackClick();
        orderBy = 'Nama';
        await getCustomerDetails();
        update();
        break;
      case 'Mengikut abjad Z-A':
        Haptic.feedbackClick();
        descending.value = true;
        currentlySelected = value;
        orderBy = 'Nama';
        await getCustomerDetails();
        update();
        break;
      case 'Susun mengikut masa':
        Haptic.feedbackClick();
        orderBy = 'timeStamp';
        descending.value = true;
        currentlySelected = value;
        await getCustomerDetails();
        update();
        break;
    }
  }

  void deleteUser(String uid, String nama) {
    Get.dialog(
      AlertDialog(
        title: const Text('Amaran!'),
        content: const Text(
          'Jika anda membuang pelanggan ini, segala maklumat sejarah baiki dan data peribadi pada pelanggan ini akan dipadam!',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              var firestoreDelete = FirebaseFirestore.instance;
              await firestoreDelete
                  .collection('customer')
                  .doc(uid)
                  .collection('repair history')
                  .get()
                  .then((value) {
                for (var element in value.docs) {
                  firestoreDelete
                      .collection('customer')
                      .doc(uid)
                      .collection('repair history')
                      .doc(element.id)
                      .delete();
                }
              });

              await firestoreDelete.collection('customer').doc(uid).delete();
              Get.back();
              Get.back();
              ShowSnackbar.success(
                  'Selesai!', 'Pelanggan $nama telah dipadam', false);
              Haptic.feedbackSuccess();
              getCustomerDetails();
            },
            child: Text(
              'Padam',
              style: TextStyle(color: Colors.amber[900]),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Batal',
            ),
          ),
        ],
      ),
    );
  }

  void addToJobsheet(String nama, String phone, String email, String uid) {
    Haptic.feedbackClick();
    Get.toNamed(MyRoutes.jobsheet, arguments: [true, nama, phone, email, uid]);
  }

  void launchCaller(String noFon) async {
    Haptic.feedbackClick();
    final url = "tel:$noFon";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      Get.back();
      ShowSnackbar.error('Kesalahan Telah berlaku',
          'Nombor telefon tidak dapat diakses', false);
    }
  }

  void launchSms(String noFon) async {
    Haptic.feedbackClick();
    final url = "sms:$noFon";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      Get.back();
      ShowSnackbar.error(
          'Kesalahan Telah berlaku', 'SMS tidak dapat diakses', false);
    }
  }

  void sorting(IconMenu value) {
    switch (value) {
      case PopupSortMenu.ascending:
        descending.value = false;
        Haptic.feedbackClick();
        orderBy = 'Nama';
        getCustomerDetails();
        update();
        break;
      case PopupSortMenu.descending:
        Haptic.feedbackClick();
        descending.value = true;
        orderBy = 'Nama';
        getCustomerDetails();
        update();
        break;
      case PopupSortMenu.time:
        Haptic.feedbackClick();
        orderBy = 'timeStamp';
        descending.value = true;
        getCustomerDetails();
        update();
        break;
    }
  }

  Future<void> getCustomerDetails() async {
    await _firestore
        .orderBy(orderBy, descending: descending.value)
        .get()
        .then((snapshot) {
      getFromFirestore = snapshot.docs;

      status.value = '';
      // searchResultList('');
      customerList = List.from(getFromFirestore);
      update();
      customerListRead.value = customerList.length.toString();
    });
  }

  // void searchResultList(String query) {
  //   List showResult = [];
  //   if (query != '') {
  //     // perform search
  //     for (var customerSnapshot in getFromFirestore) {
  //       var title = CustomerSuggestion.getCustomer(customerSnapshot)
  //           .title
  //           .toLowerCase();

  //       var noPhone = CustomerSuggestion.getCustomer(customerSnapshot)
  //           .phoneNumber
  //           .toLowerCase();

  //       if (title.contains(query.toLowerCase())) {
  //         showResult.add(customerSnapshot);
  //       } else if (noPhone.contains(query.toLowerCase())) {
  //         showResult.add(customerSnapshot);
  //       }
  //     }
  //   } else {
  //     showResult = List.from(getFromFirestore);
  //   }
  //   customerList = showResult;
  //   // update();
  // }
}
