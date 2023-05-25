import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/config/smarphone_brand.dart';
import 'package:admin_panel/home/controller/sparepart_controller.dart';
import 'package:admin_panel/spareparts/model/sparepart_search.dart';
import 'package:admin_panel/spareparts/widget/list_spareparts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllSparepartsView extends GetView<SparepartController> {
  const AllSparepartsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: ModelBrands.brandsTab.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Spareparts'),
          actions: [
            IconButton(
              onPressed: () {
                Haptic.feedbackClick();
                showSearch(
                  context: context,
                  delegate: SparepartsSearch(),
                );
              },
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {
                Haptic.feedbackClick();
                Get.toNamed(MyRoutes.sparepartsAdd);
              },
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
        body: GetBuilder<SparepartController>(
          assignId: true,
          autoRemove: false,
          builder: (logic) {
            return GestureDetector(
              onTap: () => controller.isSearch.value = false,
              child: TabBarView(
                physics: const BouncingScrollPhysics(),
                children: [
                  for (var i = 0; i < ModelBrands.brandsTab.length; i++)
                    ListSpareparts(
                      list: i == 0
                          ? controller.spareparts
                          : controller.spareparts.where((e) {
                              return e.model.toString().toLowerCase().contains(
                                  ModelBrands.brandsTab[i].text!.toLowerCase());
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
