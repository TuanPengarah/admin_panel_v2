import 'package:admin_panel/config/routes.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class TechnicianController extends GetxController {
  List technicians = [];
  Future getTechList;

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
      'jumlahKeuntungan': technician['jumlahKeuntungan'],
      'jumlahRepair': technician['jumlahRepair'],
    };

    var params = <String, String>{
      'id': technician['id'],
    };

    Get.toNamed(MyRoutes.technicianDetails,
        parameters: params, arguments: payload);
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
      technicians..sort((a,b) => a['nama'].compareTo(b['nama']));
    });
    update();
  }
}
