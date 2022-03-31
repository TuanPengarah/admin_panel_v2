import 'package:admin_panel/API/firestoreAPI.dart';
import 'package:admin_panel/POS/controller/payment_controller.dart';
import 'package:admin_panel/calculator/controller/price_calc_controller.dart';
import 'package:admin_panel/cash_flow/controller/cashflow_controller.dart';
import 'package:admin_panel/chat/controller/chat_controller.dart';
import 'package:admin_panel/graph/graph_controller.dart';
import 'package:admin_panel/home/controller/customer_controller.dart';
import 'package:admin_panel/home/controller/home_controller.dart';
import 'package:admin_panel/home/controller/other_controller.dart';
import 'package:admin_panel/home/controller/sparepart_controller.dart';
import 'package:admin_panel/jobsheet/controller/history_controller.dart';
import 'package:admin_panel/jobsheet/controller/jobsheet_controller.dart';
import 'package:admin_panel/pdf/controller/cashflow_statement_pdf_controller.dart';
import 'package:admin_panel/price_list/controller/pricelist_controller.dart';
import 'package:admin_panel/sms/controller/sms_controller.dart';
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
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => GraphController(), fenix: true);
    Get.lazyPut(() => SparepartController(), fenix: true);
    Get.lazyPut(() => CustomerController(), fenix: true);
    Get.lazyPut(() => OtherController(), fenix: true);
  }
}

class JobSheetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => JobsheetController());
    Get.lazyPut(() => FirestoreContoller());
    Get.lazyPut(() => FirestoreContoller());
  }
}

class JobSheetHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => JobsheetHistoryController());
  }
}

class CashFlowBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CashFlowController());
  }
}

class PosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentController());
    Get.lazyPut(() => PriceCalculatorController());
  }
}

class AllRecordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CashFlowController());
  }
}

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatController());
  }
}

class MonthlyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GraphController());
  }
}

class CashFlowStatementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CashFlowStatementController());
    Get.lazyPut(() => GraphController());
  }
}

class SMSBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SMSController());
  }
}
