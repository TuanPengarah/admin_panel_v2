import 'package:admin_panel/calculator/controller/price_calc_controller.dart';
import 'package:admin_panel/calculator/widget/widget_price_calc.dart';
import 'package:another_xlider/another_xlider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PriceCalculatorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _priceController = Get.put(PriceCalculatorController());
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text('Pengiraan Harga'),
            expandedHeight: 300,
            pinned: true,
            elevation: 3,
            flexibleSpace: PriceCalculatorWidget().cardPrice(),
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
                        values: [0],
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
                              '$lowerValue';
                          _priceController.supplierPrice.value = double.parse(
                                  _priceController.supplierPriceTitle.text)
                              .toStringAsFixed(0);
                        },
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
