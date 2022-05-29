import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/smarphone_brand.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:admin_panel/price_list/controller/pricelist_controller.dart';
import 'package:admin_panel/price_list/model/pricelist_model.dart';
import 'package:admin_panel/price_list/widget/pricelist_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

class PriceListView extends StatelessWidget {
  final _controller = Get.find<PriceListController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: ModelBrands.brandsTab.length,
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() {
            return _controller.isSearch.value == false
                ? Text('Senarai Harga')
                : TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                        autofocus: true,
                        style: TextStyle(color: Colors.white),
                        textInputAction: TextInputAction.search,
                        textCapitalization: TextCapitalization.characters,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          hoverColor: Colors.white,
                          focusColor: Colors.white,
                          fillColor: Colors.white,
                          hintText: 'Cari Senarai Harga...',
                          hintStyle: TextStyle(color: Colors.white60),
                          filled: false,
                          border: UnderlineInputBorder(),
                          enabledBorder: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(),
                        )),
                    onSuggestionSelected: (suggestion) {
                      _controller.isSearch.value = false;
                    },
                    suggestionsCallback: (String pattern) {
                      return _controller.priceList.where((e) =>
                          '${e.parts} ${e.model}'
                              .contains(pattern.toUpperCase()));
                    },
                    itemBuilder:
                        (BuildContext context, PriceListModel pricelist) {
                      return ListTile(
                        title: Text('${pricelist.parts} ${pricelist.model}'),
                        subtitle: Text('RM ${pricelist.harga}'),
                        onTap: () {
                          _controller.isSearch.value = false;
                          Haptic.feedbackClick();
                          _controller.priceListInfo(pricelist);
                        },
                        onLongPress: () {
                          _controller.isSearch.value = false;
                          Clipboard.setData(
                              ClipboardData(text: pricelist.id.toString()));
                          ShowSnackbar.success(
                              'ID Disalin',
                              'ID Senarai Harga ini telah disalin pada clipboard anda',
                              false);
                        },
                      );
                    },
                    getImmediateSuggestions: false,
                    hideOnEmpty: true,
                    hideSuggestionsOnKeyboardHide: true,
                  );
          }),
          actions: [
            Obx(() {
              return _controller.isSearch.value == false
                  ? IconButton(
                      onPressed: () {
                        Haptic.feedbackSuccess();
                        _controller.isSearch.value = true;
                      },
                      icon: Icon(
                        Icons.search,
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        Haptic.feedbackError();
                        _controller.isSearch.value = false;
                      },
                      icon: Icon(Icons.close),
                    );
            }),
            IconButton(
              onPressed: () => _controller.addListDialog(isEdit: false),
              icon: Icon(Icons.add),
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
                                ModelBrands.brandsTab[i].text.toLowerCase());
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
