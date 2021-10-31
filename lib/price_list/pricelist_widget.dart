import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/price_list/controller/pricelist_controller.dart';
import 'package:admin_panel/price_list/model/pricelist_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabPriceList extends StatelessWidget {
  final List<PriceListModel> list;
  TabPriceList({@required this.list});

  final _controller = Get.find<PriceListController>();
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
        return list.length > 0
            ? RefreshIndicator(
                onRefresh: () async => await _controller.getPriceList(),
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    var pricelist = list[index];
                    return ListTile(
                      title: Text('${pricelist.parts} ${pricelist.model}'),
                      subtitle: Text('${pricelist.price}'),
                    );
                  },
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.browser_not_supported,
                      size: 120,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Maaf, tiada senarai harga ditemui untuk model ini!',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: 260,
                      height: 40,
                      child: TextButton.icon(
                        onPressed: () {
                          Haptic.feedbackClick();
                        },
                        icon: Icon(Icons.add),
                        label: Text('Tambah Senarai Harga'),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async {},
                      icon: Icon(Icons.refresh),
                      label: Text('Segar Semula'),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
