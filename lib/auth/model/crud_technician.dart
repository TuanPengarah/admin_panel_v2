import 'package:admin_panel/auth/model/technician_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CrudTechnician {
  static Future<void> createTechnician(
    String uid,
    Technician technician,
  ) async {
    final ref = FirebaseDatabase.instance.ref().child('Technician').child(uid);
    await ref.set(technician.toJson());
  }

  static Future<void> readTechnician(String uid) async {
    final ref = FirebaseDatabase.instance.ref().child('Technician').child(uid);

    ref.once().then((snapshot) {
      final json = snapshot.snapshot.value as Map<dynamic, dynamic>;
      final technician = Technician.fromJson(json);
      print('result = ${technician.nama}');
    });
  }

  static void checkTechnician(String uid) {
    FirebaseDatabase.instance
        .ref()
        .child('Technician')
        .child(uid)
        .once()
        .then((snapshot) {
      if (snapshot.snapshot.value == null || !snapshot.snapshot.exists) {
        debugPrint('bukan tech ni!');
      } else {
        debugPrint('anda tech kami!!');
      }
    });

    // if (ref == true) {
    //   print('technicianAda');
    // } else {
    //   print('xde');
    // }
  }
}
