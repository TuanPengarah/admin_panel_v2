import 'package:admin_panel/config/snackbar.dart';
import 'package:admin_panel/price_list/controller/sheet_api.dart';
import 'package:admin_panel/price_list/model/pricelist_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert' as convert;

class PriceListController extends GetxController {
  List<PriceListModel> priceList = [];
  Future getList;

  String callback = '';

  TextEditingController modelText = TextEditingController();
  TextEditingController partsText = TextEditingController();
  TextEditingController priceText = TextEditingController();

  @override
  void onInit() {
    getList = getPriceList();
    super.onInit();
  }

  Future<void> getPriceList() async {
    priceList = [];
    var data = await GoogleSheet().getList();

    var jsonPricelist = convert.jsonDecode(data.bodyString);
    jsonPricelist.forEach((value) {
      PriceListModel priceListModel = PriceListModel(
        parts: value['parts'],
        model: value['model'],
        price: value['harga'],
      );

      priceList.add(priceListModel);
      update();
    });
  }

  Future<void> addPriceList() async {
    PriceListModel priceListModel = PriceListModel(
      parts: partsText.text,
      model: modelText.text,
      price: priceText.text,
    );

    try {
      await GoogleSheet().addList(priceListModel.toParams()).then((response) {
        callback = convert.jsonDecode(response.bodyString)['STATUS'];
        ShowSnackbar.success('Data telah disimpan', callback, false);
      });
    } on Exception catch (e) {
      print(e);
      ShowSnackbar.error('Ada bug', e.toString(), false);
    }
  }

  void addListDialog() {
    Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: modelText,
              decoration: InputDecoration(hintText: 'Model'),
            ),
            TextField(
              controller: partsText,
              decoration: InputDecoration(hintText: 'Parts'),
            ),
            TextField(
              controller: priceText,
              decoration: InputDecoration(hintText: 'Harga berapa ringgek'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async => await addPriceList(),
            child: Text('Tambah'),
          ),
        ],
      ),
    );
  }
}
