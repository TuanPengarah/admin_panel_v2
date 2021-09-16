import 'package:admin_panel/config/inventory.dart';
import 'package:admin_panel/spareparts/controller/add_spareparts_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddSparepartStepper {
  final _controller = Get.find<AddSparepartsController>();

  List<Step> getStepper() => [
        Step(
          state: _controller.currentSteps.value != 0
              ? StepState.complete
              : StepState.indexed,
          title: Text('Supplier'),
          isActive: _controller.currentSteps.value >= 0,
          content: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? Colors.grey.shade900
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10)),
            child: DropdownButton(
              underline: SizedBox(),
              items: Inventory.supplier.map((String value) {
                return DropdownMenuItem(
                  child: Text(
                    Inventory.getSupplierCode(
                      value.toString(),
                    ),
                  ),
                  value: value,
                );
              }).toList(),
              value: _controller.selectedSupplier.value,
              onChanged: (String newValue) {
                _controller.selectedSupplier.value = newValue;
              },
            ),
          ),
        ),
        Step(
          state: _controller.currentSteps.value > 1
              ? StepState.complete
              : StepState.indexed,
          isActive: _controller.currentSteps.value >= 1,
          title: Text('Model Smartphone'),
          content: TextField(
            controller: _controller.modelParts,
            focusNode: _controller.focusModelSmartphone,
            textCapitalization: TextCapitalization.words,
          ),
        ),
        Step(
          state: _controller.currentSteps.value > 2
              ? StepState.complete
              : StepState.indexed,
          isActive: _controller.currentSteps.value >= 2,
          title: Text('Jenis Spareparts'),
          content: TextField(
            controller: _controller.jenisParts,
            focusNode: _controller.focusJenisSparepart,
            textCapitalization: TextCapitalization.words,
          ),
        ),
        Step(
          state: _controller.currentSteps.value > 3
              ? StepState.complete
              : StepState.indexed,
          isActive: _controller.currentSteps.value >= 3,
          title: Text('Kualiti Spareparts'),
          content: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? Colors.grey.shade900
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10)),
            child: DropdownButton(
              underline: SizedBox(),
              items: Inventory.quality.map((String value) {
                return DropdownMenuItem(
                  child: Text(
                    value.toString(),
                  ),
                  value: value,
                );
              }).toList(),
              value: _controller.selectedQuality.value,
              onChanged: (String newValue) {
                _controller.selectedQuality.value = newValue;
              },
            ),
          ),
        ),
        Step(
          state: _controller.currentSteps.value > 4
              ? StepState.complete
              : StepState.indexed,
          isActive: _controller.currentSteps.value >= 4,
          title: Text('Harga'),
          content: TextField(
            keyboardType: TextInputType.number,
            controller: _controller.hargaParts,
            focusNode: _controller.focusHargaParts,
          ),
        ),
        Step(
          state: _controller.currentSteps.value > 5
              ? StepState.complete
              : StepState.indexed,
          isActive: _controller.currentSteps.value >= 5,
          title: Text('Maklumat Spareparts'),
          content: TextField(
            controller: _controller.maklumatParts,
            focusNode: _controller.focusMaklumatParts,
          ),
        ),
        Step(
          state: _controller.currentSteps.value > 6
              ? StepState.complete
              : StepState.indexed,
          isActive: _controller.currentSteps.value >= 6,
          title: Text('Kuantiti'),
          content: TextField(
            controller: _controller.kuantitiParts,
            focusNode: _controller.focusKuantitiParts,
            keyboardType: TextInputType.number,
          ),
        ),
        Step(
          isActive: _controller.currentSteps.value >= 6,
          title: Text('Kepastian'),
          content: Container(),
        ),
      ];
}
