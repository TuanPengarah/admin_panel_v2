import 'package:admin_panel/API/sqlite.dart';
import 'package:admin_panel/auth/controller/firebaseAuth_controller.dart';
import 'package:admin_panel/auth/model/technician_model.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class TechnicianController extends GetxController {
  List<Technician> technicians = [];
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
      'name': technician.nama,
      'email': technician.email,
      'cawangan': technician.cawangan,
      'jawatan': technician.jawatan,
      'photoURL': technician.photoURL,
      'photoURL1': _authController.photoURL.value,
      'jumlahKeuntungan': technician.jumlahKeuntungan,
      'jumlahRepair': technician.jumlahRepair,
      'uid': _authController.userUID.value,
      'token': technician.token,
    };

    var params = <String, String>{
      'id': technician.id,
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
                    .ref()
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
    bool internet = await InternetConnectionChecker().hasConnection;
    if (internet == true) {
      await FirebaseDatabase.instance
          .ref()
          .child('Technician')
          .once()
          .then((snapshot) async {
        Map<dynamic, dynamic> values = snapshot.snapshot.value;
        technicians = [];
        try {
          await DatabaseHelper.instance.deleteTechnicianCache();
        } catch (e) {
          debugPrint(e.toString());
        }
        values.forEach((key, value) {
          technicians.add(Technician.fromJson(value));
          DatabaseHelper.instance
              .addTechnicianCache(Technician.fromJson(value));
        });
        technicians..sort((a, b) => a.nama.compareTo(b.nama));
      });
      update();
    } else {
      technicians = [];
      var cache = await DatabaseHelper.instance.getTechnicianCache();
      technicians = cache;
      print('jumlah technician = ${technicians.length}');
      technicians..sort((a, b) => a.nama.compareTo(b.nama));
      update();
    }
  }
}
