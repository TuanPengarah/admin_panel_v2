import 'package:admin_panel/API/sqlite.dart';
import 'package:admin_panel/config/inventory.dart';
import 'package:admin_panel/spareparts/controller/history_spareparts_controller.dart';
import 'package:admin_panel/spareparts/model/sparepart_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class HistorySparepartsView extends StatelessWidget {
  final _historyController = Get.put(HistorySparepartsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sejarah Spareparts'),
      ),
      body: Center(
        child: GetBuilder<HistorySparepartsController>(
          assignId: true,
          builder: (logic) {
            return FutureBuilder<List<Spareparts>>(
              future: DatabaseHelper.instance.getSparepartsHistory(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Spareparts>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: InkWell(child: Text('Memuatkan data...')),
                  );
                }
                if (snapshot.data.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 120,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Tiada sejarah penambahan Spareparts ditemui!',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  );
                }
                return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, i) {
                      Spareparts history = snapshot.data[i];
                      return Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        child: ListTile(
                          leading: Icon(Icons.history),
                          title: Text(
                              '${history.model} ${history.jenisSpareparts}'),
                          subtitle:
                              Text(Inventory.getSupplierCode(history.supplier)),
                          trailing: Text('RM${history.harga}'),
                          onTap: () => _historyController.detailsDialog(
                            jenisParts: history.jenisSpareparts,
                            model: history.model,
                            kualiti: history.kualiti,
                            supplier: history.supplier,
                            maklumatParts: history.maklumatSpareparts,
                            harga: history.harga,
                          ),
                        ),
                        secondaryActions: [
                          IconSlideAction(
                            icon: Icons.delete,
                            caption: 'Buang',
                            color: Colors.red,
                            onTap: () async {
                              _historyController
                                  .deleteHistory(int.parse(history.partsID));
                            },
                          ),
                        ],
                      );
                    });
              },
            );
          },
        ),
      ),
    );
  }
}
