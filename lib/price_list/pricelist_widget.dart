import 'package:admin_panel/price_list/controller/pricelist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabPriceList extends StatelessWidget {
  final _controller = Get.put(PriceListController());
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _controller.getList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: _controller.priceList.length,
          itemBuilder: (BuildContext context, int index) {
            var pricelist = _controller.priceList[index];
            return ListTile(
              title: Text('${pricelist.parts} ${pricelist.model}'),
              subtitle: Text('${pricelist.price}'),
            );
          },
        );
      },
    );
  }
}
