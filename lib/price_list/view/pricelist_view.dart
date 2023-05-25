import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/smarphone_brand.dart';
import 'package:admin_panel/price_list/controller/pricelist_controller.dart';
import 'package:admin_panel/price_list/model/price_list_search.dart';
import 'package:admin_panel/price_list/widget/pricelist_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PriceListView extends StatelessWidget {
  final _controller = Get.put(PriceListController());

  PriceListView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: ModelBrands.brandsTab.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Senarai Harga'),
          actions: [
            IconButton(
              onPressed: () {
                Haptic.feedbackClick();
                showSearch(
                  context: context,
                  delegate: PriceListSearch(),
                );
              },
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () => _controller.addListDialog(isEdit: false),
              icon: const Icon(Icons.add),
            ),
          ],
          bottom: TabBar(
            labelColor: Get.theme.colorScheme.onBackground,
            indicatorColor: Get.theme.colorScheme.tertiary,
            isScrollable: true,
            tabs: ModelBrands.brandsTab,
          ),
        ),
        body: GetBuilder<PriceListController>(builder: (logic) {
          return GestureDetector(
            onTap: () => _controller.isSearch.value = false,
            child: TabBarView(
              children: [
                for (var i = 0; i < ModelBrands.brandsTab.length; i++)
                  TabPriceList(
                    list: i == 0
                        ? _controller.priceList
                        : _controller.priceList.where((e) {
                            return e.model.toString().toLowerCase().contains(
                                ModelBrands.brandsTab[i].text!.toLowerCase());
                          }).toList(),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
