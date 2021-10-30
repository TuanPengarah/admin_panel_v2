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
                ListSpareparts(
                  list: controller.spareparts,
                ),
                ListSpareparts(
                  list: controller.spareparts
                      .where((e) => e['Model']
                          .toString()
                          .toLowerCase()
                          .contains(ModelBrands.iphone.toLowerCase()))
                      .toList(),
                ),
                ListSpareparts(
                  list: controller.spareparts
                      .where((e) => e['Model']
                          .toString()
                          .toLowerCase()
                          .contains(ModelBrands.xiaomi.toLowerCase()))
                      .toList(),
                ),
                ListSpareparts(
                  list: controller.spareparts
                      .where((e) => e['Model']
                          .toString()
                          .toLowerCase()
                          .contains(ModelBrands.redmi.toLowerCase()))
                      .toList(),
                ),
                ListSpareparts(
                  list: controller.spareparts
                      .where((e) => e['Model']
                          .toString()
                          .toLowerCase()
                          .contains(ModelBrands.poco.toLowerCase()))
                      .toList(),
                ),
                ListSpareparts(
                  list: controller.spareparts
                      .where((e) => e['Model']
                          .toString()
                          .toLowerCase()
                          .contains(ModelBrands.samsung.toLowerCase()))
                      .toList(),
                ),
                ListSpareparts(
                  list: controller.spareparts
                      .where((e) => e['Model']
                          .toString()
                          .toLowerCase()
                          .contains(ModelBrands.huawei.toLowerCase()))
                      .toList(),
                ),
                ListSpareparts(
                  list: controller.spareparts
                      .where((e) => e['Model']
                          .toString()
                          .toLowerCase()
                          .contains(ModelBrands.oppo.toLowerCase()))
                      .toList(),
                ),
                ListSpareparts(
                  list: controller.spareparts
                      .where((e) => e['Model']
                          .toString()
                          .toLowerCase()
                          .contains(ModelBrands.vivo.toLowerCase()))
                      .toList(),
                ),
                ListSpareparts(
                  list: controller.spareparts
                      .where((e) => e['Model']
                          .toString()
                          .toLowerCase()
                          .contains(ModelBrands.realme.toLowerCase()))
                      .toList(),
                ),
                ListSpareparts(
                  list: controller.spareparts
                      .where((e) => e['Model']
                          .toString()
                          .toLowerCase()
                          .contains(ModelBrands.oneplus.toLowerCase()))
                      .toList(),
                ),
                ListSpareparts(
                  list: controller.spareparts
                      .where((e) => e['Model']
                          .toString()
                          .toLowerCase()
                          .contains(ModelBrands.lenovo.toLowerCase()))
                      .toList(),
                ),
                ListSpareparts(
                  list: controller.spareparts
                      .where((e) => e['Model']
                          .toString()
                          .toLowerCase()
                          .contains(ModelBrands.htc.toLowerCase()))
                      .toList(),
                ),
                ListSpareparts(
                  list: controller.spareparts
                      .where((e) => e['Model']
                          .toString()
                          .toLowerCase()
                          .contains(ModelBrands.asus.toLowerCase()))
                      .toList(),
                ),
                ListSpareparts(
                  list: controller.spareparts
                      .where((e) => e['Model']
                          .toString()
                          .toLowerCase()
                          .contains(ModelBrands.nokia.toLowerCase()))
                      .toList(),
                ),
                ListSpareparts(
                  list: controller.spareparts
                      .where((e) => e['Model']
                          .toString()
                          .toLowerCase()
                          .contains(ModelBrands.sony.toLowerCase()))
                      .toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
