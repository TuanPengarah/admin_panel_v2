import 'package:admin_panel/config/smarphone_brand.dart';
import 'package:admin_panel/price_list/pricelist_widget.dart';
import 'package:flutter/material.dart';

class PriceListView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: ModelBrands.brandsTab.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Senarai Harga'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.refresh),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.add),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: ModelBrands.brandsTab,
          ),
        ),
        body: TabBarView(
          children: [
            TabPriceList(),
            TabPriceList(),
            TabPriceList(),
            TabPriceList(),
            TabPriceList(),
            TabPriceList(),
            TabPriceList(),
            TabPriceList(),
            TabPriceList(),
            TabPriceList(),
            TabPriceList(),
            TabPriceList(),
            TabPriceList(),
            TabPriceList(),
            TabPriceList(),
            TabPriceList(),
          ],
        ),
      ),
    );
  }
}
