import 'package:admin_panel/auth/controller/firebaseAuth_controller.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TechnicianController extends GetxController {
  List technicians = [];
  Future getTechList;
  final _authController = Get.find<AuthController>();

  @override
  void onInit() {
    getTechList = getTechnician();
    super.onInit();
  }

  void techInfo(int i) {
    var technician = technicians[i];

    var payload = {
      'name': technician['nama'],
      'email': technician['email'],
      'cawangan': technician['cawangan'],
      'jawatan': technician['jawatan'],
      'photoURL': technician['photoURL'],
      'photoURL1': _authController.photoURL.value,
      'jumlahKeuntungan': technician['jumlahKeuntungan'],
      'jumlahRepair': technician['jumlahRepair'],
      'uid': _authController.userUID.value,
      'token': technician['token'],
    };

    var params = <String, String>{
      'id': technician['id'],
    };

    Get.toNamed(MyRoutes.technicianDetails,
        parameters: params, arguments: payload);
  }

  Future<void> deleteTechnician(
      String url, String uid, String namaStaff) async {
    String photoLocation = '${namaStaff.toLowerCase().replaceAll(' ', '')}.jpg';
    Get.dialog(
      AlertDialog(
        title: Text('Buang Staff?'),
        content: Text(
            'Jika anda teruskan, staff ini tidak boleh menggunakan aplikasi ini lagi! Adakah anda pasti?'),
        actions: [
          TextButton(
            onPressed: () async {
              if (url != '') {
                print('nak deleted ye');
                await FirebaseStorage.instance
                    .ref('technicians/photoURL/$photoLocation')
                    .delete();
              }
              try {
                await FirebaseDatabase.instance
                    .reference()
                    .child('Technician')
                    .child(uid)
                    .remove()
                    .then((value) async {
                  await getTechnician();
                  Get.back();
                  Get.back();
                  Haptic.feedbackSuccess();
                  ShowSnackbar.success('Buang Staff Berjaya!',
                      'Staff ini telah dibuang dari pelayan', false);
                });
              } on Exception catch (e) {
                Haptic.feedbackError();
                Get.back();
                ShowSnackbar.error('Buang Staff Gagal',
                    'Gagal untuk membuang staff dari pelayan: $e', false);
              }
            },
            child: Text(
              'Buang',
              style: TextStyle(
                color: Colors.amber[900],
              ),
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

  Future<void> getTechnician() async {
    await FirebaseDatabase.instance
        .reference()
        .child('Technician')
        .once()
        .then((snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      technicians = [];
      values.forEach((key, value) {
        technicians.add(value);
      });
      technicians..sort((a, b) => a['nama'].compareTo(b['nama']));
    });
    update();
  }
}
