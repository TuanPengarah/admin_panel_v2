import 'package:admin_panel/API/sqlite.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:admin_panel/home/model/suggestion.dart';
import 'package:admin_panel/price_list/controller/sheet_api.dart';
import 'package:admin_panel/price_list/model/pricelist_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'dart:convert' as convert;

class PriceListController extends GetxController {
  List<PriceListModel> priceList = [];
  Future<Response> getList;

  TextEditingController modelText = TextEditingController();
  TextEditingController partsText = TextEditingController();
  TextEditingController priceText = TextEditingController();

  FocusNode modelFocus = FocusNode();
  FocusNode partsFocus = FocusNode();
  FocusNode priceFocus = FocusNode();

  var isSearch = false.obs;
  var offlineMode = false.obs;

  @override
  void onInit() {
    getList = getPriceList();
    super.onInit();
  }

  void activateOffline() {
    if (priceList.isNotEmpty) {
      offlineMode.value = true;
    }
    update();
  }

  Future<Response> getPriceList() async {
    var data = await GoogleSheet().getList().timeout(Duration(seconds: 10));
    if (data.isOk) {
      priceList = [];

      var jsonPricelist = convert.jsonDecode(data.bodyString);
      await DatabaseHelper.instance.deleteCachePriceList();
      jsonPricelist.forEach((value) {
        PriceListModel priceListModel = PriceListModel(
          parts: value['parts'],
          model: value['model'],
          price: value['harga'],
          id: value['id'],
        );
        priceList.add(priceListModel);
        priceList.sort((a, b) => a.parts.compareTo(b.parts));

        DatabaseHelper.instance.addCachePriceList(priceListModel);
        update();
      });
    } else if (data.status.connectionError == true) {
      priceList = await DatabaseHelper.instance.getCachePriceList();
      priceList.sort((a, b) => a.parts.compareTo(b.parts));
      Haptic.feedbackError();
    }
    update();
    return data;
  }

  Future<void> addPriceList() async {
    String callback = '';
    var status = 'Menyediakan senarai anda ke Google Sheet...'.obs;
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    Get.dialog(
      AlertDialog(
        title: Text(
          'Menambah ke Google Sheet',
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.grey),
            SizedBox(height: 10),
            Obx(() {
              return Text(
                status.value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              );
            }),
          ],
        ),
      ),
    );
    PriceListModel priceListModel = PriceListModel(
      parts: partsText.text,
      model: modelText.text,
      price: int.parse(priceText.text),
      id: int.parse(id),
    );
    PartsSuggestion partsSuggestion = PartsSuggestion(parts: partsText.text);

    ModelSuggestion modelSuggestion = ModelSuggestion(model: modelText.text);

    try {
      status.value = 'Menambah senarai harga ke Google Sheet...';
      await GoogleSheet()
          .addList(priceListModel.addParams())
          .then((response) async {
        callback = convert.jsonDecode(response.bodyString)['STATUS'];
        status.value = 'Menambah data sqlite...';
        await DatabaseHelper.instance.addModelSuggestion(modelSuggestion);
        await DatabaseHelper.instance.addPartsSuggestion(partsSuggestion);
        status.value = 'Selesai!';
        await getPriceList();
        Haptic.feedbackSuccess();
        Get.back();
        reset();
        ShowSnackbar.success(
            'Senarai telah disimpan',
            'Senarai disimpan ke Google Sheet anda. Status penghantaran: $callback',
            false);
      });
    } on Exception catch (e) {
      status.value = 'Kesalahan telah berlaku';
      print(e);
      Get.back();
      Haptic.feedbackError();
      ShowSnackbar.error(
          'Senarai tidak dapat ditambah',
          'Kesalahan telah berlaku: ${e.toString()}. Status Penghantaran: $callback',
          false);
    }
  }

  // Future<void> deletePriceList(int id) async {
  //   PriceListModel priceListModel = PriceListModel(id: id);
  //   await GoogleSheet().deleteList(priceListModel.deleteParams()).then((value) {
  //     print(value.bodyString);
  //   });
  // }

  void addListDialog() {
    Get.dialog(
      GestureDetector(
        onTap: () => Get.focusScope.unfocus(),
        child: AlertDialog(
          title: Text('Tambah Senarai Harga'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: modelText,
                  focusNode: modelFocus,
                  autofocus: true,
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'Model'),
                ),
                suggestionsCallback: (String pattern) async =>
                    await DatabaseHelper.instance.getModelSuggestion(pattern),
                onSuggestionSelected: (ModelSuggestion suggestion) {
                  partsFocus.requestFocus();
                  return modelText.text = suggestion.model;
                },
                itemBuilder: (BuildContext context, ModelSuggestion data) {
                  return ListTile(
                    title: Text(data.model),
                  );
                },
                getImmediateSuggestions: false,
                hideOnEmpty: true,
                hideSuggestionsOnKeyboardHide: true,
              ),
              SizedBox(height: 15),
              TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: partsText,
                  focusNode: partsFocus,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(labelText: 'Parts'),
                ),
                suggestionsCallback: (String pattern) async =>
                    await DatabaseHelper.instance.getPartsSuggestion(pattern),
                onSuggestionSelected: (PartsSuggestion suggestion) {
                  priceFocus.requestFocus();
                  return partsText.text = suggestion.parts;
                },
                itemBuilder: (BuildContext context, PartsSuggestion data) {
                  return ListTile(
                    title: Text(data.parts),
                  );
                },
                getImmediateSuggestions: false,
                hideOnEmpty: true,
                hideSuggestionsOnKeyboardHide: true,
              ),
              SizedBox(height: 15),
              TextField(
                controller: priceText,
                focusNode: priceFocus,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga',
                  hintText: 'RM',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (modelText.text.isNotEmpty &&
                    partsText.text.isNotEmpty &&
                    priceText.text.isNotEmpty) {
                  Get.dialog(
                    AlertDialog(
                      title: Text('Adakah Anda Pasti?'),
                      content: Text(
                          'Pastikan maklumat yang telah diberikan adalah benar!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Haptic.feedbackError();
                            Get.back();
                          },
                          child: Text(
                            'Batal',
                            style: TextStyle(color: Colors.amber.shade900),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Haptic.feedbackClick();
                            Get.back();
                            Get.back();
                            addPriceList();
                          },
                          child: Text('Pasti'),
                        ),
                      ],
                    ),
                  );
                } else {
                  Haptic.feedbackError();

                  ShowSnackbar.error('Kesalahan telah berlaku!',
                      'Sila masukkan semua maklumat dengan betul', false);
                }
              },
              child: Text('Tambah'),
            ),
          ],
        ),
      ),
    );
  }

  void reset() {
    modelText.text = '';
    partsText.text = '';
    priceText.text = '';
  }
}
