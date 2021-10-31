import 'package:admin_panel/config/smarphone_brand.dart';
import 'package:admin_panel/price_list/controller/pricelist_controller.dart';
import 'package:admin_panel/price_list/pricelist_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PriceListView extends StatelessWidget {
  final _controller = Get.find<PriceListController>();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: ModelBrands.brandsTab.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Senarai Harga'),
          actions: [
            IconButton(
              onPressed: () async => await _controller.getPriceList(),
              icon: Icon(Icons.refresh),
            ),
            IconButton(
              onPressed: _controller.addListDialog,
              icon: Icon(Icons.add),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: ModelBrands.brandsTab,
          ),
        ),
        body: GetBuilder<PriceListController>(builder: (logic) {
          return TabBarView(
            children: [
              for (var i = 0; i < ModelBrands.brandsTab.length; i++)
                TabPriceList(
                  list: i == 0
                      ? _controller.priceList
                      : _controller.priceList.where((e) {
                          return e.model.toString().toLowerCase().contains(
                              ModelBrands.brandsTab[i].text.toLowerCase());
                        }).toList(),
                ),
            ],
          );
        }),
      ),
    );
  }
}
