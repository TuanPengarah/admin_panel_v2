import 'package:admin_panel/config/supplier.dart';
import 'package:admin_panel/cust_overview/model/popupmenu_overview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsSpareparts extends StatelessWidget {
  final _params = Get.parameters;
  final _data = Get.arguments;

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
                  PopupMenuButton<IconMenuOverview>(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    // onSelected: (value) => _overviewController
                    //     .popupMenuSelected(value, _data[0], _data[1]),
                    itemBuilder: (context) => PopupMenuOverview.items
                        .map(
                          (i) => PopupMenuItem<IconMenuOverview>(
                            value: i,
                            child: ListTile(
                                leading: Icon(i.icon), title: Text(i.text)),
                          ),
                        )
                        .toList(),
                  ),
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
                              onTap: () {},
                              child: ListTile(
                                leading: Icon(Icons.hardware),
                                title: Text('Jenis Spareparts'),
                                subtitle: Text(_data['Jenis Spareparts']),
                              ),
                            ),
                          ),
                          Card(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {},
                              child: ListTile(
                                leading: Icon(Icons.phone_android),
                                title: Text('Model'),
                                subtitle: Text(_data['Model']),
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
                                subtitle: Text(_data['Tarikh']),
                              ),
                            ),
                          ),
                          Card(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {},
                              child: ListTile(
                                leading: Icon(Icons.phonelink_setup),
                                title: Text('Kualiti'),
                                subtitle: Text(_data['Kualiti']),
                              ),
                            ),
                          ),
                          Card(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {},
                              child: ListTile(
                                leading: Icon(Icons.precision_manufacturing),
                                title: Text('Supplier'),
                                subtitle: Text(Supplier.getSupplierCode(
                                    _data['Supplier'])),
                              ),
                            ),
                          ),
                          Card(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {},
                              child: ListTile(
                                leading: Icon(Icons.summarize),
                                title: Text('Maklumat Spareparts'),
                                subtitle: Text(_data['Maklumat Spareparts']),
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
                              onTap: () {},
                              child: ListTile(
                                leading: Icon(Icons.request_quote),
                                title: Text('Harga Supplier'),
                                subtitle: Text('RM ${_data['Harga']}'),
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
                                subtitle: Text('RM --'),
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
