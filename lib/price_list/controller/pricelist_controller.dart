import 'package:admin_panel/API/sqlite.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:admin_panel/home/model/suggestion.dart';
import 'package:admin_panel/price_list/model/price_list_api.dart';
import 'package:admin_panel/price_list/model/pricelist_field.dart';
import 'package:admin_panel/price_list/model/pricelist_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

class PriceListController extends GetxController {
  List<PriceListModel> priceList = [];
  Future<String> getList;

  TextEditingController modelText = TextEditingController();
  TextEditingController partsText = TextEditingController();
  TextEditingController priceText = TextEditingController();

  FocusNode modelFocus = FocusNode();
  FocusNode partsFocus = FocusNode();
  FocusNode priceFocus = FocusNode();

  var isSearch = false.obs;
  var offlineMode = false.obs;
  var internet = true.obs;
  var errorText = 'Sambungan internet tidak dapat ditemui'.obs;

  @override
  void onInit() {
    checkInternet();
    getList = getPriceList();

    super.onInit();
  }

  void checkInternet() async {
    bool getInternet = await InternetConnectionChecker().hasConnection;
    internet.value = getInternet;
  }

  void priceListInfo(PriceListModel pricelist) {
    DateTime dt = DateTime.fromMillisecondsSinceEpoch(pricelist.id);
    var tarikh = DateFormat('dd/MM/yyyy').format(dt);
    Get.bottomSheet(
      Material(
        color: Get.theme.canvasColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 25),
            Text(
              '${pricelist.parts} ${pricelist.model}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              'RM ${pricelist.harga}',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 5),
            Text(
              'Tarikh dikemaskini: $tarikh',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 15),
            Divider(),
            ListTile(
              leading: Icon(Icons.copy),
              title: Text('Salin Senarai Harga'),
              onTap: () => copyPricelistText(pricelist),
            ),
            ListTile(
              leading: Icon(Icons.fingerprint),
              title: Text('Salin ID'),
              onTap: () => copyPricelistID(pricelist),
            ),
            internet.value == true
                ? ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit'),
                    onTap: () => addListDialog(
                      isEdit: true,
                      list: pricelist,
                      model: pricelist.model,
                      parts: pricelist.parts,
                      harga: pricelist.harga.toString(),
                    ),
                  )
                : const SizedBox(),
            internet.value == true
                ? ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Buang'),
                    onTap: () => Get.dialog(
                      AlertDialog(
                        title: Text('Adakah anda pasti?'),
                        content: Text(
                            'Adakah anda pasti untuk membuang senarai harga ${pricelist.parts} ${pricelist.model}'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Haptic.feedbackError();
                              Get.back();

                              deletePriceList(pricelist.id);
                            },
                            child: Text('Pasti'),
                          ),
                          TextButton(
                            onPressed: () {
                              Haptic.feedbackClick();
                              Get.back();
                            },
                            child: Text(
                              'Batal',
                              style: TextStyle(
                                color: Colors.amber[900],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void deletePriceList(int id) async {
    Get.dialog(AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
        ],
      ),
    ));
    await PriceListApi().delete(id);
    await Future.delayed(Duration(seconds: 2));
    await getPriceList();
    update();
    Get.back();
    Get.back();
    ShowSnackbar.success(
        'Berjaya Dipadam', 'Senarai harga anda telah dipadam', false);
  }

  void copyPricelistText(PriceListModel pricelist) {
    Haptic.feedbackClick();
    Clipboard.setData(ClipboardData(
            text:
                '${pricelist.parts} ${pricelist.model}\nHarga: RM ${pricelist.harga}'))
        .onError((error, stackTrace) => ShowSnackbar.error(
            'Kesalahan telah berlaku',
            'Gagal untuk menyalin ke papan clipboard anda: $error',
            false))
        .whenComplete(() => ShowSnackbar.success(
            'Senarai harga telah harga disalin',
            'Senarai harga telah disalin ke papan clipboard anda',
            false));
    Get.back();
  }

  void copyPricelistID(PriceListModel pricelist) {
    Haptic.feedbackClick();
    Clipboard.setData(ClipboardData(text: '${pricelist.id}'))
        .onError((error, stackTrace) => ShowSnackbar.error(
            'Kesalahan telah berlaku',
            'Gagal untuk menyalin id ke papan clipboard anda: $error',
            false))
        .whenComplete(() => ShowSnackbar.success(
            'ID telah harga disalin',
            'Senarai harga ID (${pricelist.id}) telah disalin ke papan clipboard anda',
            false));
    Get.back();
  }

  void activateOffline() async {
    offlineMode.value = true;
    priceList = [];
    List<PriceListModel> cache =
        await DatabaseHelper.instance.getCachePriceList();
    priceList.addAll(cache);
    priceList.sort((a, b) => a.parts.compareTo(b.parts));
    Haptic.feedbackError();
    update();
  }

  Future<String> getPriceList() async {
    bool adaInternet = await InternetConnectionChecker().hasConnection;
    try {
      if (adaInternet == true) {
        var data = await PriceListApi.getAll().timeout(Duration(seconds: 10),
            onTimeout: () {
          errorText.value = 'Sambungan Tamat';
          throw Exception('Connection Failed!');
        });
        priceList = [];

        await DatabaseHelper.instance.deleteCachePriceList();

        data.forEach((value) {
          priceList.add(value);
          priceList.sort((a, b) => a.parts.compareTo(b.parts));

          DatabaseHelper.instance.addCachePriceList(value);
          update();
        });
        return 'success';
      } else {
        errorText.value = 'Internet Tidak Ditemui!';
      }
    } on Exception catch (e) {
      errorText.value = e.toString();
      return e.toString();
    }
    update();
    return 'failed';
  }

  Future<void> addPriceList() async {
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
    PartsSuggestion partsSuggestion = PartsSuggestion(parts: partsText.text);

    ModelSuggestion modelSuggestion = ModelSuggestion(model: modelText.text);

    try {
      status.value = 'Menambah senarai harga ke Google Sheet...';

      final partsPrice = PriceListModel(
        model: modelText.text,
        parts: partsText.text,
        harga: int.parse(priceText.text),
        id: int.parse(id),
      );

      await PriceListApi.insert([partsPrice.toJson()]);
      status.value = 'Menambah data sqlite...';
      await DatabaseHelper.instance.addModelSuggestion(modelSuggestion);
      await DatabaseHelper.instance.addPartsSuggestion(partsSuggestion);
      status.value = 'Selesai!';
      await Future.delayed(Duration(seconds: 2));
      await getPriceList();
      Haptic.feedbackSuccess();
      Get.back();
      reset();
      ShowSnackbar.success('Senarai telah disimpan',
          'Senarai disimpan ke Google Sheet anda!', false);
    } on Exception catch (e) {
      status.value = 'Kesalahan telah berlaku';
      print(e);
      Get.back();
      Haptic.feedbackError();
      ShowSnackbar.error('Senarai tidak dapat ditambah',
          'Kesalahan telah berlaku: ${e.toString()}.', false);
    }
  }

  // Future<void> deletePriceList(int id) async {
  //   PriceListModel priceListModel = PriceListModel(id: id);
  //   await GoogleSheet().deleteList(priceListModel.deleteParams()).then((value) {
  //     print(value.bodyString);
  //   });
  // }

  void addListDialog({
    @required bool isEdit,
    PriceListModel list,
    String model,
    String parts,
    String harga,
  }) {
    if (isEdit == true) {
      modelText.text = model;
      partsText.text = parts;
      priceText.text = harga;
      Get.back();
    }
    Get.dialog(
      GestureDetector(
        onTap: () => Get.focusScope.unfocus(),
        child: AlertDialog(
          title: Text(
              isEdit == false ? 'Tambah Senarai Harga' : 'Edit Senarai Harga'),
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
                          onPressed: () async {
                            Haptic.feedbackClick();
                            Get.back();
                            Get.back();
                            if (isEdit == false) {
                              addPriceList();
                            } else {
                              Get.dialog(AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(),
                                  ],
                                ),
                              ));
                              await PriceListApi.update(
                                id: list.id,
                                partsKey: PriceListField.parts,
                                hargaKey: PriceListField.harga,
                                modelKey: PriceListField.model,
                                hargaValue: priceText.text,
                                modelValue: modelText.text,
                                partsValue: partsText.text,
                              ).onError((error, stackTrace) =>
                                  ShowSnackbar.error('Kesalahan telah berlaku',
                                      '${error.toString()}', false));

                              await getPriceList();

                              Get.back();
                              ShowSnackbar.success(
                                  'Berjaya di kemasini',
                                  'Senarai harga anda telah berjaya di kemaskini',
                                  false);
                            }
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
              child: Text(isEdit == false ? 'Tambah' : 'Simpan Perubahan'),
            ),
          ],
        ),
      ),
    ).whenComplete(() => reset());
  }

  void reset() {
    modelText.text = '';
    partsText.text = '';
    priceText.text = '';
  }
}
