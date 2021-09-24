import 'package:admin_panel/calculator/controller/price_calc_controller.dart';
import 'package:admin_panel/config/inventory.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/cust_overview/model/popupmenu_overview.dart';
import 'package:admin_panel/home/controller/sparepart_controller.dart';
import 'package:admin_panel/spareparts/controller/details_spareparts_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsSpareparts extends GetView<SparepartController> {
  final _params = Get.parameters;
  final _data = Get.arguments;
  final _priceController = Get.put(PriceCalculatorController());

  final _detailsController = Get.put(DetailsSparepartsController());

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Hero(
        tag: _params['id'],
        child: Scaffold(
          body: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                flexibleSpace: FlexibleSpaceBar(
                  title: Text('Maklumat Spareparts'),
                  centerTitle: true,
                ),
                expandedHeight: 250,
                floating: true,
                pinned: true,
                actions: [
                  Obx(() {
                    return _detailsController.editMode.value == false
                        ? PopupMenuButton<IconMenuOverview>(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            onSelected: (value) =>
                                _detailsController.popupMenuSeleceted(
                                    value,
                                    _params['id'],
                                    _data['Model'],
                                    _data['Jenis Spareparts']),
                            itemBuilder: (context) => PopupMenuOverview.items
                                .map(
                                  (i) => PopupMenuItem<IconMenuOverview>(
                                    value: i,
                                    child: ListTile(
                                        leading: Icon(i.icon),
                                        title: Text(i.text)),
                                  ),
                                )
                                .toList(),
                          )
                        : IconButton(
                            onPressed: () => _detailsController
                                .saveSpareparts(_params['id']),
                            icon: Icon(Icons.save),
                          );
                  }),
                ],
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Card(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () =>
                                  _detailsController.editJenisSpareparts(),
                              child: ListTile(
                                leading: Obx(() {
                                  return _detailsController.editMode.value ==
                                          true
                                      ? Icon(Icons.edit)
                                      : Icon(Icons.hardware);
                                }),
                                title: Text('Jenis Spareparts'),
                                subtitle: Obx(() {
                                  return Text(
                                      _detailsController.jenisParts.value);
                                }),
                              ),
                            ),
                          ),
                          Card(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () => _detailsController.editModel(),
                              child: ListTile(
                                leading: Obx(() {
                                  return _detailsController.editMode.value ==
                                          true
                                      ? Icon(Icons.edit)
                                      : Icon(Icons.phone_android);
                                }),
                                title: Text('Model'),
                                subtitle: Obx(() {
                                  return Text(_detailsController.model.value);
                                }),
                              ),
                            ),
                          ),
                          Card(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {},
                              child: ListTile(
                                leading: Icon(Icons.pending_actions),
                                title: Text('Tarikh Kemaskini'),
                                subtitle: Text(
                                    controller.convertEpoch(_data['Tarikh'])),
                              ),
                            ),
                          ),
                          Card(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () => _detailsController.editKualiti(),
                              child: ListTile(
                                leading: Obx(() {
                                  return _detailsController.editMode.value ==
                                          true
                                      ? Icon(Icons.edit)
                                      : Icon(Icons.phonelink_setup);
                                }),
                                title: Text('Kualiti'),
                                subtitle: Obx(() {
                                  return Text(_detailsController
                                      .selectedKualitiParts.value);
                                }),
                              ),
                            ),
                          ),
                          Card(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () => _detailsController.editSupplier(),
                              child: ListTile(
                                leading: Obx(() {
                                  return _detailsController.editMode.value ==
                                          true
                                      ? Icon(Icons.edit)
                                      : Icon(Icons.precision_manufacturing);
                                }),
                                title: Text('Supplier'),
                                subtitle: Obx(() {
                                  return Text(Inventory.getSupplierCode(
                                      _detailsController
                                          .selectedSupplier.value));
                                }),
                              ),
                            ),
                          ),
                          Card(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () =>
                                  _detailsController.editMaklumatParts(),
                              child: ListTile(
                                leading: Obx(() {
                                  return _detailsController.editMode.value ==
                                          true
                                      ? Icon(Icons.edit)
                                      : Icon(Icons.summarize);
                                }),
                                title: Text('Maklumat Spareparts'),
                                subtitle: Obx(() {
                                  return Text(
                                      _detailsController.maklumatParts.value);
                                }),
                              ),
                            ),
                          ),
                          Card(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {},
                              child: ListTile(
                                leading: Icon(Icons.fingerprint),
                                title: Text('Parts ID'),
                                subtitle: Text(_params['id']),
                              ),
                            ),
                          ),
                          Card(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () => _detailsController.editHargaParts(),
                              child: ListTile(
                                leading: Obx(() {
                                  return _detailsController.editMode.value ==
                                          true
                                      ? Icon(Icons.edit)
                                      : Icon(Icons.request_quote);
                                }),
                                title: Text('Harga Supplier'),
                                subtitle: Obx(() {
                                  return Text(
                                      'RM ${_detailsController.hargaParts.value}');
                                }),
                              ),
                            ),
                          ),
                          Card(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {},
                              child: ListTile(
                                leading: Icon(Icons.payment),
                                title: Text('Harga Jual'),
                                subtitle: Text(
                                    'RM ${_priceController.calculateFromWidget(int.parse(_detailsController.hargaParts.value)).toStringAsFixed(0)}'),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text.rich(
                            TextSpan(
                              text:
                                  'Harga jual adalah harga yang disarankan oleh AINA dan ditetapkan untuk waranti 1 bulan, sila klik di ',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13),
                              children: [
                                TextSpan(
                                  text: 'sini untuk melihat Pengiraan Harga!',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      var payload = {
                                        'hargaParts':
                                            _detailsController.hargaParts.value,
                                        'waranti': 30
                                      };
                                      Get.toNamed(MyRoutes.priceCalc,
                                          arguments: payload);
                                    },
                                  style: TextStyle(
                                    color: Get.theme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
