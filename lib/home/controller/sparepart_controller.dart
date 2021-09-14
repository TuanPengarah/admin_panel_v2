import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class SparepartController extends GetxController {
  List spareparts = [];
  var totalPartsPrice = 00.00.obs;
  Future getPartList;

  @override
  void onInit() {
    getPartList = getSparepartsList();
    super.onInit();
  }

  Future<void> getSparepartsList() async {
    print('running');
    await FirebaseDatabase.instance
        .reference()
        .child("Spareparts")
        .orderByChild('Model')
        .once()
        .then((snapshot) {
      spareparts.clear();
      totalPartsPrice.value = 00.00;
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        spareparts.add(values);
        totalPartsPrice.value += int.parse(values['Harga']);
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
