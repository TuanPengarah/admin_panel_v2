import 'package:admin_panel/calculator/controller/price_calc_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PriceCalculatorWidget {
  final _priceController = Get.put(PriceCalculatorController());

  FlexibleSpaceBar cardPrice() {
    return FlexibleSpaceBar(
      background: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: Get.width - 80,
              height: 180,
              decoration: BoxDecoration(
                color: Get.theme.canvasColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.27),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => Text(
                          'RM ${_priceController.jumlah.value.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                    Text(
                      'Anggaran Harga',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 30),
                    Obx(() {
                      return _details('Harga Supplier: ',
                          'RM ${_priceController.supplierPrice}');
                    }),
                    SizedBox(height: 7),
                    Obx(
                      () => _details(
                          'Waranti ', _priceController.tempohWarranti.value),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _details(String title, String content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$title',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '$content',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Row titleContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Harga dari supplier',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 120,
          height: 70,
          child: TextField(
            controller: _priceController.supplierPriceTitle,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            onChanged: (newText) {
              try {
                _priceController.supplierPrice.value = newText;
                _priceController.calculatePrice(
                    int.parse(_priceController.supplierPrice.value));
              } on Exception catch (e) {
                print(e);
              }
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
            ),
          ),
        ),
      ],
    );
  }

  Row titleContent2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Jumlah Tempoh Waranti',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Obx(() => Text(
              _priceController.tempohWarranti.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            )),
      ],
    );
  }
}
