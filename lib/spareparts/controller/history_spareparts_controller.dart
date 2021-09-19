import 'package:admin_panel/API/sqlite.dart';
import 'package:admin_panel/spareparts/controller/add_spareparts_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistorySparepartsController extends GetxController {
  final _addSpareparts = Get.find<AddSparepartsController>();
  void detailsDialog({
    @required String model,
    @required String jenisParts,
    @required String kualiti,
    @required String supplier,
    @required String harga,
    @required String maklumatParts,
  }) {
    Get.dialog(
      AlertDialog(
        title: Text('Maklumat Spareparts'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _info('Model: ', model),
            _info('Jenis: ', jenisParts),
            _info('Kualiti: ', kualiti),
            _info('Supplier: ', supplier),
            _info('Harga: ', 'RM$harga'),
            _info('Maklumat: ', maklumatParts),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _addSpareparts.modelParts.text = model;
              _addSpareparts.jenisParts.text = jenisParts;
              _addSpareparts.hargaParts.text = harga;
              _addSpareparts.maklumatParts.text = maklumatParts;
              _addSpareparts.selectedSupplier.value = supplier;
              _addSpareparts.selectedQuality.value = kualiti;
              Get.back();
              Get.back();
            },
            child: Text(
              'Tambah ke spareparts',
            ),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Tutup'),
          )
        ],
      ),
    );
  }

  Row _info(String title, String info) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(
          info,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void deleteHistory(int id) {
    print(id);
    Get.dialog(
      AlertDialog(
        title: Text('Adakah anda pasti'),
        content: Text('Adakah anda pasti untuk membuang item ini?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              await DatabaseHelper.instance.deleteSparepartsHistory(id);
              Get.back();
              update();
            },
            child: Text(
              'Buang',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
