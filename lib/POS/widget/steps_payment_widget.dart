import 'package:admin_panel/POS/controller/payment_controller.dart';
import 'package:admin_panel/config/management.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class StepsPayment {
  final _controller = Get.find<PaymentController>();

  List<Step> stepper() => [
        Step(
          state: _controller.currentSteps.value != 0
              ? StepState.complete
              : StepState.indexed,
          isActive: _controller.currentSteps.value >= 0,
          title: const Text('Jenis Stock / Servis'),
          content: Container(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() {
                  return Text(
                    _controller.currentStock.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
                TextButton(
                  onPressed: () => _controller.chooseServices(),
                  child: const Text('Klik sini untuk pilih...'),
                ),
              ],
            ),
          ),
        ),
        Step(
          state: _controller.currentSteps.value > 1
              ? StepState.complete
              : StepState.indexed,
          isActive: _controller.currentSteps.value >= 1,
          title: const Text('Pilih Juruteknik'),
          content: Container(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => Text(
                    _controller.currentTechnician.value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _controller.chooseTechnician(),
                  child: const Text('Pilih juruteknik lain..'),
                ),
              ],
            ),
          ),
        ),
        Step(
          state: _controller.currentSteps.value > 2
              ? StepState.complete
              : StepState.indexed,
          isActive: _controller.currentSteps.value >= 2,
          title: const Text('Waranti'),
          content: Container(
            width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? Colors.grey.shade900
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10)),
            child: DropdownButton(
              icon: Container(),
              underline: const SizedBox(),
              items: Management.waranti.map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(
                    value.toString(),
                  ),
                );
              }).toList(),
              value: _controller.selectedWaranti.value,
              onChanged: (String? newValue) {
                _controller.selectedWaranti.value = newValue.toString();
                _controller.changeWaranti();
                _controller.calculatePrice(_controller.hargaSpareparts);
              },
            ),
          ),
        ),
        Step(
          state: _controller.currentSteps.value > 3
              ? StepState.complete
              : StepState.indexed,
          isActive: _controller.currentSteps.value >= 3,
          title: const Text('Harga'),
          content: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Obx(
                  () => TextField(
                    focusNode: _controller.focusHarga,
                    controller: _controller.priceText,
                    keyboardType: GetPlatform.isIOS
                        ? const TextInputType.numberWithOptions(
                            signed: true, decimal: true)
                        : TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,4}'))
                    ],
                    onSubmitted: ((value) => _controller.nextSteps()),
                    decoration: InputDecoration(
                        hintText: _controller.recommendedPrice.value.toString(),
                        errorText: _controller.errPriceMiss.value == true
                            ? 'Sila masukkan harga!'
                            : null),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Harga yang disarankan oleh AINA: RM${_controller.recommendedPrice.value}',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
        ),
        Step(
          state: _controller.currentSteps.value > 4
              ? StepState.complete
              : StepState.indexed,
          isActive: _controller.currentSteps.value >= 4,
          title: const Text('Status Invois'),
          content: Container(
            width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? Colors.grey.shade900
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10)),
            child: DropdownButton(
              icon: Container(),
              underline: const SizedBox(),
              items: Management.dahBayar.map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(
                    value.toString(),
                  ),
                );
              }).toList(),
              value: _controller.selectedDibayar.value,
              onChanged: (String? newValue) {
                _controller.selectedDibayar.value = newValue.toString();
                // _controller.changeWaranti();
                // _controller.calculatePrice(_controller.hargaSpareparts);
              },
            ),
          ),
        ),
        Step(
          state: _controller.currentSteps.value > 5
              ? StepState.complete
              : StepState.indexed,
          isActive: _controller.currentSteps.value >= 5,
          title: const Text('Kepastian'),
          content: Column(
            children: [
              _info('Jenis Stock: ', _controller.currentStock.value),
              _info('Juruteknik: ', _controller.currentTechnician.value),
              _info('Waranti: ', _controller.selectedWaranti.value),
              _info('Harga: ', 'RM${_controller.priceText.text}'),
              _info('Status Invois: ', _controller.selectedDibayar.value),
            ],
          ),
        ),
      ];

  Row _info(String title, String info) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(title)),
        Expanded(
          child: Text(
            info,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
