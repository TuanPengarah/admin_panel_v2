import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/config/smarphone_brand.dart';
import 'package:admin_panel/home/controller/sparepart_controller.dart';
import 'package:admin_panel/spareparts/widget/list_spareparts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllSparepartsView extends GetView<SparepartController> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: ModelBrands.brandsTab.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Spareparts'),
          actions: [
            IconButton(
              onPressed: () async => await controller.refreshDialog(true),
              icon: Icon(
                Icons.refresh,
              ),
            ),
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
            return TabBarView(
              physics: BouncingScrollPhysics(),
              children: [
                for (var i = 0; i < ModelBrands.brandsTab.length; i++)
                  ListSpareparts(
                    list: i == 0
                        ? controller.spareparts
                        : controller.spareparts.where((e) {
                            return e['Model'].toString().toLowerCase().contains(
                                ModelBrands.brandsTab[i].text.toLowerCase());
                          }).toList(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
