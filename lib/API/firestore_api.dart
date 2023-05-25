import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FirestoreContoller extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  String _tarikh = '';
  var status = ''.obs;

  @override
  void onInit() {
    getDates();
    super.onInit();
  }

  void getDates() {
    var current = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy');
    _tarikh = formatter.format(current);
  }

  Future<String> addJobSheet({
    required String email,
    required String nama,
    required String noPhone,
    required String mysid,
    required String model,
    required String password,
    required String kerosakkan,
    required int harga,
    required String technician,
    required String remarks,
    String? userUID,
    bool? isExisting,
  }) async {
    if (isExisting == false) {
      status.value = 'Menyediakan data pelanggan...';
      debugPrint('Menyediakan data pelanggan...');
      FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary',
        options: Firebase.app().options,
      );
      await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: '123456')
          .then((credential) async {
        userUID = credential.user!.uid.toString();
        await _firestore.collection('customer').doc(userUID).set({
          'Email': email,
          'Nama': nama,
          'No Phone': noPhone,
          'Points': 0,
          'Tarikh': _tarikh,
          'UID': userUID,
          'photoURL': '',
          'timeStamp': FieldValue.serverTimestamp(),
        });
        debugPrint(userUID);
        await credential.user!.updateDisplayName(nama);
        status.value = 'Tahniah! data pelanggan telah di setkan!';
      }).catchError((err) async {
        app.delete();
        Haptic.feedbackError();
        status.value = 'Kesalahan telah berlaku! : $err';
        ShowSnackbar.error('Kesalahan telah berlaku!', err, false);
        app.delete();
        await Future.delayed(const Duration(seconds: 3));
        Get.back();
      });

      await app.delete();
    }
    // Set Repair History Collection
    Map<String, dynamic> repairHistory = {
      'MID': mysid,
      'Model': model,
      'Password': password,
      'Kerosakkan': kerosakkan,
      'Harga': harga,
      'Tarikh': _tarikh,
      'Tarikh Waranti': _tarikh,
      'isWarranty': false,
      'Technician': technician,
      'Remarks': remarks,
      'Status': 'Belum Selesai',
      'timeStamp': FieldValue.serverTimestamp(),
    };

    // Set MySID Collection
    Map<String, dynamic> mySID = {
      'Database UID': userUID,
      'Nama': nama,
      'No Phone': noPhone,
      'Percent': 0.1,
      'MID': mysid,
      'Model': model,
      'Password': password,
      'Kerosakkan': kerosakkan,
      'Harga': harga,
      'Remarks': '*$remarks',
      'Tarikh': _tarikh,
      'Technician': technician,
      'Status': 'In Queue',
      'isPayment': false,
      'timeStamp': FieldValue.serverTimestamp(),
    };

    //Tambah repair log status
    Map<String, dynamic> repairLog = {
      'Repair Log': 'Pesanan diterima',
      'isError': false,
      'timeStamp': FieldValue.serverTimestamp(),
    };

// Tambah data ke repair history customer
    status.value = 'Menambah repair history dari data pelanggan...';
    await _firestore
        .collection('customer')
        .doc(userUID)
        .collection('repair history')
        .doc(mysid)
        .set(repairHistory)
        .then((value) => status.value = 'Tambah ke repair history selesai')
        .catchError((err) {
      status.value = 'Kesalahan telah berlaku! : $err';
      ShowSnackbar.error('Kesalahan telah berlaku!', err, false);
      return err;
    });

    // Tambah data ke MySID Collection
    status.value = 'Menambah status MySID server collection...';

    await _firestore
        .collection('MyrepairID')
        .doc(mysid)
        .set(mySID)
        .then((value) => status.value = 'Tambah ke MySID selesai')
        .catchError((err) {
      status.value = 'Kesalahan telah berlaku! : $err';
      ShowSnackbar.error('Kesalahan telah berlaku!', err, false);
      return err;
    });

    await _firestore
        .collection('MyrepairID')
        .doc(mysid)
        .collection('repair log')
        .add(repairLog)
        .then((value) => status.value = 'Tambah ke repair log selesai')
        .catchError((err) {
      status.value = 'Kesalahan telah berlaku! : $err';
      ShowSnackbar.error('Kesalahan telah berlaku!', err, false);
      return err;
    });

    // Tambah point

    status.value = 'Menambah transaction Points...';
    if (isExisting == false) {
      await _firestore
          .collection('customer')
          .doc(userUID)
          .update({'Points': 10})
          .then((value) => status.value = 'operation-completed')
          .catchError((err) {
            status.value = 'Kesalahan telah berlaku! : $err';
            ShowSnackbar.error('Kesalahan telah berlaku!', err, false);
            return err;
          });
    } else {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('customer').doc(userUID);
      await _firestore
          .runTransaction((transaction) async {
            DocumentSnapshot snap = await transaction.get(documentReference);
            if (!snap.exists) {
              status.value = 'Pengguna tidak dapat ditemui';
              ShowSnackbar.error('Kesalahan telah berlaku!',
                  'Pengguna tidak dapat ditemui', false);
            }
            int newPoints = snap.get('Points');
            transaction.update(documentReference, {'Points': newPoints + 1});
          })
          .then((value) => status.value = 'operation-completed')
          .catchError((err) {
            status.value = 'Kesalahan telah berlaku! : $err';
            ShowSnackbar.error('Kesalahan telah berlaku!', err, false);
            return err;
          });
    }

    return status.value;
  }
}
