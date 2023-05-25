import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/home/controller/sparepart_controller.dart';
import 'package:admin_panel/spareparts/model/sparepart_model.dart';
import 'package:admin_panel/spareparts/widget/list_spareparts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SparepartsSearch extends SearchDelegate {
  final _sparepartsController = Get.find<SparepartController>();

  List<Spareparts> _getSpareparts() {
    List<Spareparts> suggestion =
        _sparepartsController.spareparts.where((searchResult) {
      return '${searchResult.jenisSpareparts.toLowerCase()} ${searchResult.model.toLowerCase()}'
          .contains(query.toLowerCase());
    }).toList();
    return suggestion;
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
        icon: const Icon(
          Icons.close,
        ),
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
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Spareparts> suggestion = _getSpareparts();
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
                    'Spareparts atau jenis spareparts \'$query\' tidak dapat ditemui',
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
    List<Spareparts> suggestion = _getSpareparts();
    return query.isNotEmpty
        ? ListView.builder(
            itemCount: query.isEmpty ? 0 : suggestion.length,
            itemBuilder: (BuildContext context, int index) {
              var spareparts = suggestion[index];
              return ListSpareparts().listSpareparts(spareparts);
            },
          )
        : const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.manage_search,
                    size: 120,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Cari spareparts dengan memasukkan kata kunci \'Jenis Sparepart\' atau \'Model Smartphone\'',
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
