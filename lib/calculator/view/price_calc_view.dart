import 'package:admin_panel/calculator/controller/price_calc_controller.dart';
import 'package:admin_panel/calculator/widget/widget_price_calc.dart';
import 'package:admin_panel/price_list/controller/pricelist_controller.dart';
import 'package:another_xlider/another_xlider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PriceCalculatorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _priceController = Get.put(PriceCalculatorController());
    final _priceListController = Get.put(PriceListController());
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text('Pengiraan Harga'),
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Get.theme.colorScheme.primary,
            foregroundColor: Get.theme.colorScheme.surface,
            elevation: 3,
            flexibleSpace: PriceCalculatorWidget().cardPrice(),
            actions: [
              IconButton(
                onPressed: () {
                  _priceListController.priceText.text =
                      _priceController.jumlah.value.toStringAsFixed(0);
                  _priceListController.addListDialog(isEdit: false);
                },
                icon: Icon(Icons.add),
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PriceCalculatorWidget().titleContent(),
                      FlutterSlider(
                        values: [
                          double.parse(_priceController.supplierPrice.value)
                        ],
                        max: 2000,
                        min: 0,
                        trackBar: FlutterSliderTrackBar(
                          activeTrackBarHeight: 40,
                          inactiveTrackBarHeight: 40,
                          inactiveTrackBar: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Get.isDarkMode
                                ? Colors.grey.shade900
                                : Colors.black12,
                          ),
                          activeTrackBar: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Get.theme.primaryColor,
                          ),
                        ),
                        onDragging: (handlerIndex, lowerValue, upperValue) {
                          _priceController.supplierPriceTitle.text =
                              '${lowerValue.toStringAsFixed(0)}';
                          _priceController.supplierPrice.value = double.parse(
                                  _priceController.supplierPriceTitle.text)
                              .toStringAsFixed(0);
                          _priceController.calculatePrice(
                              int.parse(_priceController.supplierPrice.value));
                        },
                      ),
                      SizedBox(height: 50),
                      PriceCalculatorWidget().titleContent2(),
                      SizedBox(height: 20),
                      FlutterSlider(
                        values: [
                          _priceController.tempohWarranti.value == '1 Bulan'
                              ? 30
                              : 1
                        ],
                        max: 4,
                        min: 1,
                        fixedValues: [
                          FlutterSliderFixedValue(
                              percent: 1, value: "1 Minggu"),
                          FlutterSliderFixedValue(
                              percent: 30, value: "1 Bulan"),
                          FlutterSliderFixedValue(
                              percent: 60, value: "2 Bulan"),
                          FlutterSliderFixedValue(
                              percent: 100, value: "3 Bulan"),
                        ],
                        trackBar: FlutterSliderTrackBar(
                          activeTrackBarHeight: 40,
                          inactiveTrackBarHeight: 40,
                          inactiveTrackBar: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Get.isDarkMode
                                ? Colors.grey.shade900
                                : Colors.black12,
                          ),
                          activeTrackBar: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Get.theme.primaryColor,
                          ),
                        ),
                        onDragging: (handlerIndex, lowerValue, upperValue) {
                          _priceController.tempohWarranti.value = lowerValue;
                          _priceController.changeWaranti();
                          _priceController.calculatePrice(
                              int.parse(_priceController.supplierPrice.value));
                        },
                      ),
                      SizedBox(height: 50),
                      Text(
                        'Pengiraan harga ini kemungkinan besar adalah tidak tepat! Sila semak jenis spareparts dan semak kesukaran untuk membaiki peranti tersebut!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
