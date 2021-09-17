import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/inventory.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:admin_panel/cust_overview/model/popupmenu_overview.dart';
import 'package:admin_panel/home/controller/sparepart_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsSparepartsController extends GetxController {
  final _sparepartsController = Get.find<SparepartController>();

  final _data = Get.arguments;

  var editMode = false.obs;

  var jenisParts = ''.obs;
  var model = ''.obs;
  var selectedKualitiParts = ''.obs;
  var maklumatParts = ''.obs;
  var hargaParts = ''.obs;
  var selectedSupplier = ''.obs;

  var errJenisParts = false.obs;
  var errMode = false.obs;
  var errMaklumatParts = false.obs;
  var errHarga = false.obs;

  final jenisPartsController = TextEditingController();
  final modelController = TextEditingController();
  final maklumatPartsController = TextEditingController();
  final hargaPartsController = TextEditingController();

  @override
  void onInit() {
    initEditable();
    super.onInit();
  }

  void initEditable() {
    jenisParts.value = _data['Jenis Spareparts'];
    model.value = _data['Model'];
    selectedKualitiParts.value = _data['Kualiti'];
    maklumatParts.value = _data['Maklumat Spareparts'];
    hargaParts.value = _data['Harga'];
    selectedSupplier.value = _data['Supplier'];

    jenisPartsController.text = jenisParts.value;
    modelController.text = model.value;
    maklumatPartsController.text = maklumatParts.value;
    hargaPartsController.text = hargaParts.value;
  }

  void editJenisSpareparts() {
    if (editMode.value == true) {
      Get.dialog(
        AlertDialog(
          title: Text('Sunting Jenis Spareparts'),
          content: Obx(() {
            return TextField(
              controller: jenisPartsController,
              textCapitalization: TextCapitalization.characters,
              autofocus: true,
              decoration: InputDecoration(
                errorText: errJenisParts.value == true
                    ? 'Sila masukkan ruangan ini'
                    : null,
              ),
            );
          }),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                jenisPartsController.text = jenisParts.value;
                errJenisParts.value = false;
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (jenisPartsController.text.isEmpty) {
                  errJenisParts.value = true;
                } else {
                  jenisParts.value = jenisPartsController.text;
                  errJenisParts.value = false;
                  Get.back();
                }
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      );
    }
  }

  void editModel() {
    if (editMode.value == true) {
      Get.dialog(
        AlertDialog(
          title: Text('Sunting Model Smartphone'),
          content: Obx(() {
            return TextField(
              controller: modelController,
              textCapitalization: TextCapitalization.characters,
              autofocus: true,
              decoration: InputDecoration(
                errorText:
                    errMode.value == true ? 'Sila masukkan ruangan ini' : null,
              ),
            );
          }),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                modelController.text = model.value;
                errMode.value = false;
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (modelController.text.isEmpty) {
                  errMode.value = true;
                } else {
                  model.value = modelController.text;
                  errMode.value = false;
                  Get.back();
                }
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      );
    }
  }

  void editMaklumatParts() {
    if (editMode.value == true) {
      Get.dialog(
        AlertDialog(
          title: Text('Sunting Maklumat Spareparts'),
          content: Obx(() {
            return TextField(
              controller: maklumatPartsController,
              textCapitalization: TextCapitalization.characters,
              autofocus: true,
              decoration: InputDecoration(
                errorText: errMaklumatParts.value == true
                    ? 'Sila masukkan ruangan ini'
                    : null,
              ),
            );
          }),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                maklumatPartsController.text = maklumatParts.value;
                errMaklumatParts.value = false;
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (maklumatPartsController.text.isEmpty) {
                  errMaklumatParts.value = true;
                } else {
                  maklumatParts.value = maklumatPartsController.text;
                  errMaklumatParts.value = false;
                  Get.back();
                }
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      );
    }
  }

  void editHargaParts() {
    if (editMode.value == true) {
      Get.dialog(
        AlertDialog(
          title: Text('Sunting Harga Spareparts'),
          content: Obx(() {
            return TextField(
              controller: hargaPartsController,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                errorText:
                    errHarga.value == true ? 'Sila masukkan ruangan ini' : null,
              ),
            );
          }),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                hargaPartsController.text = hargaParts.value;
                errHarga.value = false;
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (hargaPartsController.text.isEmpty) {
                  errHarga.value = true;
                } else {
                  hargaParts.value = hargaPartsController.text;
                  errHarga.value = false;
                  Get.back();
                }
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      );
    }
  }

  void editKualiti() {
    if (editMode.value == true) {
      Get.dialog(
        AlertDialog(
          title: Text('Sunting Kualiti Spareparts'),
          content: Obx(() {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? Colors.grey.shade900
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10)),
              child: DropdownButton(
                icon: SizedBox(),
                underline: SizedBox(),
                items: Inventory.quality.map((String value) {
                  return DropdownMenuItem(
                    child: Text(
                      value.toString(),
                    ),
                    value: value,
                  );
                }).toList(),
                value: selectedKualitiParts.value,
                onChanged: (String newValue) {
                  selectedKualitiParts.value = newValue;
                },
              ),
            );
          }),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                selectedKualitiParts.value = _data['Kualiti'];
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      );
    }
  }

  void editSupplier() {
    if (editMode.value == true) {
      Get.dialog(
        AlertDialog(
          title: Text('Sunting Supplier'),
          content: Obx(() {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? Colors.grey.shade900
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10)),
              child: DropdownButton(
                icon: SizedBox(),
                underline: SizedBox(),
                items: Inventory.supplier.map((String value) {
                  return DropdownMenuItem(
                    child: Text(
                      Inventory.getSupplierCode(
                        value.toString(),
                      ),
                    ),
                    value: value,
                  );
                }).toList(),
                value: selectedSupplier.value,
                onChanged: (String newValue) {
                  selectedSupplier.value = newValue;
                },
              ),
            );
          }),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                selectedSupplier.value = _data['Supplier'];
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      );
    }
  }

  void popupMenuSeleceted(
      IconMenuOverview value, String id, String model, String jenis) async {
    switch (value) {
      case PopupMenuOverview.edit:
        editMode.value = true;
        ShowSnackbar.notify('Mod suntingan aktif!',
            'Tekan butang simpan jika anda ingin menyimpan suntingan anda ke server pelanggan');
        break;
      case PopupMenuOverview.delete:
        await deleteSpareparts(id, model, jenis);
        break;
    }
  }

  Future<void> deleteSpareparts(String id, String model, String jenis) async {
    Haptic.feedbackError();
    Get.dialog(AlertDialog(
      title: Text('Adakah anda pasti?'),
      content:
          Text('Adakah anda pasti untuk membuang sparepart $jenis $model?'),
      actions: [
        TextButton(
          onPressed: () async {
            Get.dialog(
              AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
            await FirebaseDatabase.instance
                .reference()
                .child('Spareparts')
                .child(id)
                .remove()
                .then((value) async {
              await _sparepartsController.refreshDialog(false);
              Haptic.feedbackSuccess();
              Get.back();
              Get.back();
              Get.back();
              Get.back();
              ShowSnackbar.notify('Padam Spareparts',
                  'Spareparts $jenis $model telah dipadam dari server!');
            });
          },
          child: Text(
            'Buang',
            style: TextStyle(
              color: Colors.amber.shade900,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Batal'),
        ),
      ],
    ));
  }
}
