import 'package:admin_panel/config/inventory.dart';
import 'package:admin_panel/price_list/controller/pricelist_controller.dart';
import 'package:admin_panel/price_list/model/pricelist_model.dart';
import 'package:admin_panel/spareparts/controller/add_spareparts_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

class AddSparepartStepper {
  final _controller = Get.find<AddSparepartsController>();
  final _priceListController = Get.find<PriceListController>();

  List<Step> getStepper() => [
        Step(
          state: _controller.currentSteps.value != 0
              ? StepState.complete
              : StepState.indexed,
          title: const Text('Supplier'),
          isActive: _controller.currentSteps.value >= 0,
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? Colors.grey.shade900
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10)),
            child: DropdownButton(
              underline: const SizedBox(),
              items: Inventory.supplier.map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(
                    Inventory.getSupplierCode(
                      value.toString(),
                    ),
                  ),
                );
              }).toList(),
              value: _controller.selectedSupplier.value,
              onChanged: (String? newValue) {
                _controller.selectedSupplier.value = newValue.toString();
              },
            ),
          ),
        ),
        Step(
          state: _controller.currentSteps.value > 1
              ? StepState.complete
              : StepState.indexed,
          isActive: _controller.currentSteps.value >= 1,
          title: const Text('Model Smartphone'),
          content: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              controller: _controller.modelParts,
              focusNode: _controller.focusModelSmartphone,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.next,
              onSubmitted: (newText) {
                _controller.nextStepper();
              },
              decoration: InputDecoration(
                hintText: 'cth: Huawei Nova 2i, iPhone 7...',
                errorText: _controller.errModelParts.value == true
                    ? 'Sila masukkan model smartphone!'
                    : null,
              ),
            ),
            suggestionsCallback: (String pattern) =>
                _priceListController.getModelName(pattern),
            onSuggestionSelected: (PriceListModel suggestion) =>
                _controller.modelParts.text = suggestion.model,
            itemBuilder: (BuildContext context, PriceListModel data) {
              return ListTile(
                title: Text(data.model),
              );
            },
            getImmediateSuggestions: false,
            hideOnEmpty: true,
            hideSuggestionsOnKeyboardHide: true,
          ),
        ),
        Step(
          state: _controller.currentSteps.value > 2
              ? StepState.complete
              : StepState.indexed,
          isActive: _controller.currentSteps.value >= 2,
          title: const Text('Jenis Spareparts'),
          content: TextField(
            controller: _controller.jenisParts,
            focusNode: _controller.focusJenisSparepart,
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.next,
            onSubmitted: (newText) {
              _controller.nextStepper();
            },
            decoration: InputDecoration(
                hintText: 'cth: Lcd, Battery, Back Camera...',
                errorText: _controller.errJenisParts.value == true
                    ? 'Sila masukkan jenis spareparts!'
                    : null),
          ),
          // textFieldConfiguration: TextFieldConfiguration(

          // suggestionsCallback: (String pattern) async =>
          //     await DatabaseHelper.instance.getPartsSuggestion(pattern),
          // onSuggestionSelected: (PartsSuggestion suggestion) =>
          //     _controller.jenisParts.text = suggestion.parts,
          // itemBuilder: (BuildContext context, PartsSuggestion data) {
          //   return ListTile(
          //     title: Text(data.parts),
          //   );
          // },
          // getImmediateSuggestions: false,
          // hideOnEmpty: true,
          // hideSuggestionsOnKeyboardHide: true,
        ),
        Step(
          state: _controller.currentSteps.value > 3
              ? StepState.complete
              : StepState.indexed,
          isActive: _controller.currentSteps.value >= 3,
          title: const Text('Kualiti Spareparts'),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? Colors.grey.shade900
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10)),
            child: DropdownButton(
              underline: const SizedBox(),
              items: Inventory.quality.map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(
                    value.toString(),
                  ),
                );
              }).toList(),
              value: _controller.selectedQuality.value,
              onChanged: (String? newValue) {
                _controller.selectedQuality.value = newValue.toString();
              },
            ),
          ),
        ),
        Step(
          state: _controller.currentSteps.value > 4
              ? StepState.complete
              : StepState.indexed,
          isActive: _controller.currentSteps.value >= 4,
          title: const Text('Harga'),
          content: TextField(
            keyboardType: GetPlatform.isIOS
                ? const TextInputType.numberWithOptions(signed: true, decimal: true)
                : TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}'))
            ],
            controller: _controller.hargaParts,
            focusNode: _controller.focusHargaParts,
            textInputAction: TextInputAction.next,
            onSubmitted: (newText) {
              _controller.nextStepper();
            },
            decoration: InputDecoration(
                hintText: 'RM',
                errorText: _controller.errHargaParts.value == true
                    ? 'Sila masukkan harga spareparts!'
                    : null),
          ),
        ),
        Step(
          state: _controller.currentSteps.value > 5
              ? StepState.complete
              : StepState.indexed,
          isActive: _controller.currentSteps.value >= 5,
          title: const Text('Maklumat Spareparts'),
          content: TextField(
            controller: _controller.maklumatParts,
            focusNode: _controller.focusMaklumatParts,
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.next,
            onSubmitted: (newText) {
              _controller.nextStepper();
            },
            decoration: InputDecoration(
                hintText: 'cth: Warna Hitam, Tarikh 2019...',
                errorText: _controller.errMaklumatParts.value == true
                    ? 'Sila masukkan maklumat spareparts!'
                    : null),
          ),
        ),
        Step(
          state: _controller.currentSteps.value > 6
              ? StepState.complete
              : StepState.indexed,
          isActive: _controller.currentSteps.value >= 6,
          title: const Text('Kuantiti'),
          content: TextField(
            controller: _controller.kuantitiParts,
            focusNode: _controller.focusKuantitiParts,
            keyboardType: GetPlatform.isIOS
                ? const TextInputType.numberWithOptions(signed: true, decimal: true)
                : TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}'))
            ],
            textInputAction: TextInputAction.done,
            onSubmitted: (newText) {
              _controller.nextStepper();
            },
            decoration: InputDecoration(
                hintText: 'Jumlah sparepart yang diterima',
                errorText: _controller.errKuantitiParts.value == true
                    ? 'Sila masukkan kuantiti spareparts!'
                    : null),
          ),
        ),
        Step(
          isActive: _controller.currentSteps.value >= 6,
          title: const Text('Kepastian'),
          content: Column(
            children: [
              kepastianContent(
                  'Supplier: ',
                  Inventory.getSupplierCode(
                      _controller.selectedSupplier.value)),
              kepastianContent(
                  'Model Smartphone: ', _controller.modelParts.text),
              kepastianContent(
                  'Jenis Spareparts: ', _controller.jenisParts.text),
              kepastianContent(
                  'Kualiti Spareparts: ', _controller.selectedQuality.value),
              kepastianContent('Harga: ', 'RM ${_controller.hargaParts.text}'),
              kepastianContent(
                  'Maklumat Spareparts: ', _controller.maklumatParts.text),
              kepastianContent('Kuantiti: ', _controller.kuantitiParts.text),
            ],
          ),
        ),
      ];

  Widget kepastianContent(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: Text(title)),
          Expanded(
            child: Text(
              subtitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
