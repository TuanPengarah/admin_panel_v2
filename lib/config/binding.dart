import 'package:admin_panel/price_list/controller/pricelist_controller.dart';
import 'package:get/get.dart';

class PriceListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PriceListController());
  }
}
