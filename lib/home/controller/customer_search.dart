import 'package:admin_panel/home/controller/customer_controller.dart';
import 'package:admin_panel/home/page/customer_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerSearch extends SearchDelegate {
  final _customerController = Get.find<CustomerController>();

  List _getCust() {
    return _customerController.customerList.where((e) {
      return '${e['Nama'].toString().toLowerCase()} ${e['No Phone'].toString().toLowerCase()}'
          .contains(query.toLowerCase());
    }).toList();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(
          Icons.arrow_back,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    return _customerController.customerList.isEmpty
        ? Center(
            child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_off, size: 150, color: Colors.grey),
                const SizedBox(height: 10),
                Text(
                  'Pelanggan yang bernama $query tidak dapat ditemui!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ))
        : buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // _customerController.searchResultList(query);
    List suggestion = _getCust();
    return query != ''
        ? ListView.builder(
            itemCount: query.isEmpty ? 0 : suggestion.length,
            itemBuilder: ((context, i) {
              var customer = suggestion[i];
              var image = customer['photoURL'];
              return CustomerPage(false).customerTiles(customer, image);
            }),
          )
        : const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_search,
                  size: 120,
                  color: Colors.grey,
                ),
                SizedBox(height: 10),
                Text(
                  'Anda boleh cari nama atau nombor telefon pelanggan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          );
  }
}
