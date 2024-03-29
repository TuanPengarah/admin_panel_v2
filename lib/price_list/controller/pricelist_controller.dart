import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:admin_panel/price_list/model/price_list_api.dart';
import 'package:admin_panel/price_list/model/pricelist_field.dart';
import 'package:admin_panel/price_list/model/pricelist_model.dart';
import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

class PriceListController extends GetxController {
  List<PriceListModel> priceList = [];
  Future<String>? getList;

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

  List<PriceListModel> getModelName(String pattern) {
    List<PriceListModel> model =
        priceList.distinct(by: (item) => item.model.removeAllWhitespace);
    return model.where((phone) {
      return phone.model.toLowerCase().contains(pattern.toLowerCase());
    }).toList();
  }

  void checkInternet() async {
    var connect = await ConnectivityWrapper.instance.isConnected;
    bool getInternet = connect;
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
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              'RM ${pricelist.harga}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 5),
            Text(
              'Tarikh dikemaskini: $tarikh',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 15),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Salin Senarai Harga'),
              onTap: () => copyPricelistText(pricelist),
            ),
            ListTile(
              leading: const Icon(Icons.fingerprint),
              title: const Text('Salin ID'),
              onTap: () => copyPricelistID(pricelist),
            ),
            internet.value == true
                ? ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Edit'),
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
                    leading: const Icon(Icons.delete),
                    title: const Text('Buang'),
                    onTap: () => Get.dialog(
                      AlertDialog(
                        title: const Text('Adakah anda pasti?'),
                        content: Text(
                            'Adakah anda pasti untuk membuang senarai harga ${pricelist.parts} ${pricelist.model}'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Haptic.feedbackError();
                              Get.back();

                              deletePriceList(pricelist.id);
                            },
                            child: Text(
                              'Pasti',
                              style: TextStyle(
                                color: Colors.amber[900],
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Haptic.feedbackClick();
                              Get.back();
                            },
                            child: const Text('Batal'),
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
      isScrollControlled: true,
    );
  }

  void deletePriceList(int id) async {
    Get.dialog(const AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
        ],
      ),
    ));
    await PriceListApi().delete(id);
    await Future.delayed(const Duration(seconds: 2));
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
        .whenComplete(() => ShowSnackbar.success(
            'Senarai harga telah harga disalin',
            'Senarai harga telah disalin ke papan clipboard anda',
            false));
    Get.back();
  }

  void copyPricelistID(PriceListModel pricelist) {
    Haptic.feedbackClick();
    Clipboard.setData(ClipboardData(text: '${pricelist.id}')).whenComplete(() =>
        ShowSnackbar.success(
            'ID telah harga disalin',
            'Senarai harga ID (${pricelist.id}) telah disalin ke papan clipboard anda',
            false));
    Get.back();
  }

  void activateOffline() async {
    offlineMode.value = true;
    priceList = [];
    // List<PriceListModel> cache =
    //     await DatabaseHelper.instance.getCachePriceList();
    // priceList.addAll(cache);
    // priceList.sort((a, b) => a.parts.compareTo(b.parts));
    Haptic.feedbackError();
    update();
  }

  Future<String> getPriceList() async {
    try {
      var connect = await ConnectivityWrapper.instance.isConnected;
      bool adaInternet = connect;
      if (adaInternet == true) {
        var data = await PriceListApi.getAll()
            .timeout(const Duration(seconds: 10), onTimeout: () {
          errorText.value = 'Sambungan Tamat';
          throw Exception('Connection Failed!');
        });
        priceList = [];

        // await DatabaseHelper.instance.deleteCachePriceList();

        for (var value in data) {
          priceList.add(value);
          priceList.sort((a, b) => a.parts.compareTo(b.parts));
          // if (!GetPlatform.isMacOS) {
          //   DatabaseHelper.instance.addCachePriceList(value);
          // }

          update();
        }
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
        title: const Text(
          'Menambah ke Google Sheet',
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.grey),
            const SizedBox(height: 10),
            Obx(() {
              return Text(
                status.value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              );
            }),
          ],
        ),
      ),
    );
    // PartsSuggestion partsSuggestion = PartsSuggestion(parts: partsText.text);

    // ModelSuggestion modelSuggestion = ModelSuggestion(model: modelText.text);

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

      // await DatabaseHelper.instance.addModelSuggestion(modelSuggestion);
      // await DatabaseHelper.instance.addPartsSuggestion(partsSuggestion);
      status.value = 'Selesai!';
      await Future.delayed(const Duration(seconds: 2));
      await getPriceList();
      Haptic.feedbackSuccess();
      Get.back();
      reset();
      ShowSnackbar.success('Senarai telah disimpan',
          'Senarai disimpan ke Google Sheet anda!', false);
    } on Exception catch (e) {
      status.value = 'Kesalahan telah berlaku';
      debugPrint(e.toString());
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
    required bool isEdit,
    PriceListModel? list,
    String? model,
    String? parts,
    String? harga,
  }) {
    if (isEdit == true) {
      modelText.text = model.toString();
      partsText.text = parts.toString();
      priceText.text = harga.toString();
      Get.back();
    }
    Get.bottomSheet(
      GestureDetector(
        onTap: () => Get.focusScope?.unfocus(),
        child: Material(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      label: isEdit == true
                          ? const Text('Edit')
                          : const Text('Tambah'),
                      onPressed: () {
                        if (modelText.text.isNotEmpty &&
                            partsText.text.isNotEmpty &&
                            priceText.text.isNotEmpty) {
                          Get.dialog(
                            AlertDialog(
                              title: const Text('Adakah Anda Pasti?'),
                              content: const Text(
                                  'Pastikan maklumat yang telah diberikan adalah benar!'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Haptic.feedbackError();
                                    Get.back();
                                  },
                                  child: Text(
                                    'Batal',
                                    style:
                                        TextStyle(color: Colors.amber.shade900),
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
                                      Get.dialog(const AlertDialog(
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircularProgressIndicator(),
                                          ],
                                        ),
                                      ));
                                      await PriceListApi.update(
                                        id: list!.id,
                                        partsKey: PriceListField.parts,
                                        hargaKey: PriceListField.harga,
                                        modelKey: PriceListField.model,
                                        hargaValue: priceText.text,
                                        modelValue: modelText.text,
                                        partsValue: partsText.text,
                                      );

                                      await getPriceList();

                                      Get.back();
                                      ShowSnackbar.success(
                                          'Berjaya di kemasini',
                                          'Senarai harga anda telah berjaya di kemaskini',
                                          false);
                                    }
                                  },
                                  child: const Text('Pasti'),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          );
                        } else {
                          Haptic.feedbackError();

                          ShowSnackbar.error(
                              'Kesalahan telah berlaku!',
                              'Sila masukkan semua maklumat dengan betul',
                              true);
                        }
                      },
                      icon: isEdit == true
                          ? const Icon(Icons.edit)
                          : const Icon(Icons.add),
                    ),
                  ),
                  Text(
                    isEdit == false
                        ? 'Tambah Senarai Harga'
                        : 'Edit Senarai Harga',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: modelText,
                      focusNode: modelFocus,
                      autofocus: true,
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: 'Model'),
                    ),
                    suggestionsCallback: (String pattern) =>
                        getModelName(pattern),
                    onSuggestionSelected: (PriceListModel suggestion) {
                      partsFocus.requestFocus();
                      // return modelText.text = suggestion.model;
                    },
                    itemBuilder: (BuildContext context, PriceListModel data) {
                      return ListTile(
                        title: Text(data.model),
                      );
                    },
                    getImmediateSuggestions: false,
                    hideOnEmpty: true,
                    hideSuggestionsOnKeyboardHide: true,
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: partsText,
                    focusNode: partsFocus,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(labelText: 'Parts'),
                    // textFieldConfiguration: TextFieldConfiguration(
                    //   controller: partsText,
                    //   focusNode: partsFocus,
                    //   textInputAction: TextInputAction.next,
                    //   textCapitalization: TextCapitalization.characters,
                    //   decoration: InputDecoration(labelText: 'Parts'),
                    // ),
                    // suggestionsCallback: (String pattern) async =>
                    //     await DatabaseHelper.instance
                    //         .getPartsSuggestion(pattern),
                    // onSuggestionSelected: (PartsSuggestion suggestion) {
                    //   priceFocus.requestFocus();
                    //   return partsText.text = suggestion.parts;
                    // },
                    // itemBuilder: (BuildContext context, PartsSuggestion data) {
                    //   return ListTile(
                    //     title: Text(data.parts),
                    //   );
                    // },
                    // getImmediateSuggestions: false,
                    // hideOnEmpty: true,
                    // hideSuggestionsOnKeyboardHide: true,
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: priceText,
                    focusNode: priceFocus,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Harga',
                      hintText: 'RM',
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    ).whenComplete(() => reset());
  }

  void reset() {
    modelText.text = '';
    partsText.text = '';
    priceText.text = '';
  }
}
