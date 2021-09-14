import 'package:admin_panel/home/model/sparepart_mode.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class SparepartController extends GetxController {
  List spareparts = [];
  List keys = [];

  @override
  void onInit() {
    getSparepartsList();
    super.onInit();
  }

  Future<void> getSparepartsList() async {
    FirebaseDatabase.instance
        .reference()
        .child("Spareparts")
        .once()
        .then((snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        spareparts.add(values);
        keys.add(key);
      });
    });

    // FirebaseDatabase.instance
    //     .reference()
    //     .child('Spareparts')
    //     .orderByChild('Model')
    //     .equalTo('iPhone')
    //     .onChildAdded
    //     .listen((_onEntryAdded));

    // FirebaseDatabase.instance
    //     .reference()
    //     .child('Spareparts')
    //     .orderByChild('Model')
    //     .equalTo('iPhone')
    //     .onChildChanged
    //     .listen((_onEntryChanged));
  }

  // _onEntryAdded(Event event) {
  //   spareparts.add(Spareparts.fromSnapshot(event.snapshot));
  // }

  // _onEntryChanged(Event event) {
  //   var oldEntry = spareparts.singleWhere((entry) {
  //     return entry.key == event.snapshot.key;
  //   });

  //   spareparts[spareparts.indexOf(oldEntry)] =
  //       Spareparts.fromSnapshot(event.snapshot);
  // }
}
