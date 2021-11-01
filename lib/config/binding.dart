import 'package:admin_panel/API/firestoreAPI.dart';
import 'package:admin_panel/graph/graph_controller.dart';
import 'package:admin_panel/home/controller/customer_controller.dart';
import 'package:admin_panel/home/controller/home_controller.dart';
import 'package:admin_panel/home/controller/other_controller.dart';
import 'package:admin_panel/home/controller/sparepart_controller.dart';
import 'package:admin_panel/jobsheet/controller/history_controller.dart';
import 'package:admin_panel/jobsheet/controller/jobsheet_controller.dart';
import 'package:admin_panel/price_list/controller/pricelist_controller.dart';
import 'package:get/get.dart';

class PriceListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PriceListController());
  }
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => GraphController());
    Get.lazyPut(() => SparepartController());
    Get.lazyPut(() => CustomerController());
    Get.lazyPut(() => OtherController());
  }
}

class JobSheetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => JobsheetController());
    Get.lazyPut(() => FirestoreContoller());
  }
}

class JobSheetHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => JobsheetHistoryController());
  }
}