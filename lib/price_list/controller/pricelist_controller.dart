import 'package:admin_panel/price_list/controller/sheet_api.dart';
import 'package:admin_panel/price_list/model/pricelist_model.dart';
import 'package:get/get.dart';
import 'dart:convert' as convert;

class PriceListController extends GetxController {
  List<PriceListModel> priceList = [];
  Future getList;

  @override
  void onInit() {
    getList = getPriceList();
    getPriceList();
    super.onInit();
  }

  Future<void> getPriceList() async {
    var data = await GoogleSheet().getList();

    var jsonPricelist = convert.jsonDecode(data.bodyString);
    jsonPricelist.forEach((value) {
      PriceListModel priceListModel = PriceListModel(
        parts: value['parts'],
        model: value['model'],
        price: value['harga'],
      );

      priceList.add(priceListModel);
    });
  }
}
