import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/price_list/controller/pricelist_controller.dart';
import 'package:admin_panel/price_list/model/pricelist_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PriceListSearch extends SearchDelegate {
  final _priceListController = Get.find<PriceListController>();

  List<PriceListModel> _getPricelist() {
    return _priceListController.priceList.where((e) {
      return '${e.parts.toLowerCase()} ${e.model.toLowerCase()}'
          .contains(query.toLowerCase());
    }).toList();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            Haptic.feedbackError();
            close(context, null);
          } else {
            query = '';
          }
        },
        icon: Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Haptic.feedbackError();
        close(context, null);
      },
      icon: Icon(
        Icons.arrow_back,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<PriceListModel> suggestion = _getPricelist();
    return suggestion.isNotEmpty
        ? buildSuggestions(context)
        : Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.browser_not_supported,
                    size: 120,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Senarai harga \'$query\' tidak dapat ditemui',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<PriceListModel> suggestion = _getPricelist();

    return query.isNotEmpty
        ? ListView.builder(
            itemCount: query.isEmpty ? 0 : suggestion.length,
            itemBuilder: (BuildContext context, int index) {
              var pricelist = suggestion[index];
              return ListTile(
                title: Text('${pricelist.parts} ${pricelist.model}'),
                subtitle: Text('RM ${pricelist.harga}'),
                onTap: () {
                  Haptic.feedbackSuccess();
                  _priceListController.priceListInfo(pricelist);
                },
              );
            },
          )
        : Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.manage_search,
                    size: 120,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Cari senarai harga dengan memasukkan kata kunci \'Jenis Sparepart\' atau \'Model Smartphone\'',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
