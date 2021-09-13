import 'package:admin_panel/auth/model/technician_model.dart';
import 'package:firebase_database/firebase_database.dart';

class CrudTechnician {
  static Future<void> createTechnician(
    String uid,
    Technician technician,
  ) async {
    final ref =
        FirebaseDatabase.instance.reference().child('Technician').child(uid);
    await ref.set(technician.toJson());
  }

  static Future<void> readTechnician(String uid) async {
    final ref =
        FirebaseDatabase.instance.reference().child('Technician').child(uid);

    ref.once().then((snapshot) {
      final json = snapshot.value as Map<dynamic, dynamic>;
      final technician = Technician.fromJson(json);
      print('result = ${technician.nama}');
    });
  }

  static void checkTechnician(String uid) {
    FirebaseDatabase.instance
        .reference()
        .child('Technician')
        .child(uid)
        .once()
        .then((snapshot) {
      if (snapshot.value == null || !snapshot.exists) {
        print('bukan tech ni!');
      } else {
        print('anda tech kami!!');
      }
    });

    // if (ref == true) {
    //   print('technicianAda');
    // } else {
    //   print('xde');
    // }
  }
}
