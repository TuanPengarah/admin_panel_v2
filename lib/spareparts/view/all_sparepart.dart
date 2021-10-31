import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/config/smarphone_brand.dart';
import 'package:admin_panel/home/controller/sparepart_controller.dart';
import 'package:admin_panel/spareparts/widget/list_spareparts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

class AllSparepartsView extends GetView<SparepartController> {
  final _data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: ModelBrands.brandsTab.length,
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() {
            return controller.isSearch.value == false
                ? Text('Spareparts')
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
                      controller.isSearch.value = false;
                    },
                    suggestionsCallback: (String pattern) {
                      return controller.spareparts.where((e) =>
                          '${e['Jenis Spareparts']} ${e['Model']}'
                              .contains(pattern.toUpperCase()));
                    },
                    itemBuilder: (BuildContext context, spareparts) {
                      return ListTile(
                          title: Text(
                              '${spareparts['Jenis Spareparts']} ${spareparts['Model']}'),
                          subtitle: Text(spareparts['Maklumat Spareparts']),
                          trailing: Text('RM${spareparts['Harga']}'),
                          onTap: () {
                            controller.isSearch.value = false;
                            if (_data == null) {
                              var arguments = {
                                'Model': spareparts['Model'],
                                'Kualiti': spareparts['Kualiti'],
                                'Jenis Spareparts':
                                    spareparts['Jenis Spareparts'],
                                'Tarikh': spareparts['Tarikh'],
                                'Harga': spareparts['Harga'],
                                'Supplier': spareparts['Supplier'],
                                'Maklumat Spareparts':
                                    spareparts['Maklumat Spareparts'],
                              };
                              controller.goToDetails(
                                  arguments, spareparts['id']);
                            } else {
                              final data = {
                                'model':
                                    '${spareparts['Jenis Spareparts']} ${spareparts['Model']} (${spareparts['Kualiti']})',
                                'id': spareparts['id'],
                                'harga': spareparts['Harga'],
                              };
                              Get.back(result: data);
                            }
                          });
                    },
                    getImmediateSuggestions: false,
                    hideOnEmpty: true,
                    hideSuggestionsOnKeyboardHide: true,
                  );
          }),
          actions: [
            Obx(() {
              return controller.isSearch.value == false
                  ? IconButton(
                      onPressed: () {
                        Haptic.feedbackSuccess();
                        controller.isSearch.value = true;
                      },
                      icon: Icon(Icons.search),
                    )
                  : IconButton(
                      onPressed: () {
                        Haptic.feedbackError();
                        controller.isSearch.value = false;
                      },
                      icon: Icon(Icons.close),
                    );
            }),
            IconButton(
              onPressed: () {
                Haptic.feedbackClick();
                Get.toNamed(MyRoutes.sparepartsAdd);
              },
              icon: Icon(Icons.add),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: ModelBrands.brandsTab,
          ),
        ),
        body: GetBuilder<SparepartController>(
          assignId: true,
          autoRemove: false,
          builder: (logic) {
            return GestureDetector(
              onTap: () => controller.isSearch.value = false,
              child: TabBarView(
                physics: BouncingScrollPhysics(),
                children: [
                  for (var i = 0; i < ModelBrands.brandsTab.length; i++)
                    ListSpareparts(
                      list: i == 0
                          ? controller.spareparts
                          : controller.spareparts.where((e) {
                              return e['Model']
                                  .toString()
                                  .toLowerCase()
                                  .contains(ModelBrands.brandsTab[i].text
                                      .toLowerCase());
                            }).toList(),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
