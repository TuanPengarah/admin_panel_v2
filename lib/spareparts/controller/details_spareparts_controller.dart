import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/inventory.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:admin_panel/cust_overview/model/popupmenu_overview.dart';
import 'package:admin_panel/home/controller/sparepart_controller.dart';
import 'package:admin_panel/spareparts/model/sparepart_model.dart';
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

  void setArguments() {
    _data['Jenis Spareparts'] = jenisParts.value;
    _data['Model'] = model.value;
    _data['Kualiti'] = selectedKualitiParts.value;
    _data['Maklumat Spareparts'] = maklumatParts.value;
    _data['Harga'] = hargaParts.value;
    _data['Supplier'] = selectedSupplier.value;
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

  Future<void> saveSpareparts(String id) async {
    if (jenisParts.value != _data['Jenis Spareparts'] ||
        model.value != _data['Model'] ||
        selectedKualitiParts.value != _data['Kualiti'] ||
        maklumatParts.value != _data['Maklumat Spareparts'] ||
        selectedSupplier.value != _data['Supplier']) {
      Haptic.feedbackClick();
      Get.dialog(AlertDialog(
        title: const Text('Simpan perubahan?'),
        content:
            const Text('Pastikan segala maklumat pada spareparts ini adalah betul!'),
        actions: [
          TextButton(
            onPressed: () {
              editMode.value = false;
              initEditable();
              Get.back();
            },
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Spareparts spareparts = Spareparts(
                model: model.value,
                jenisSpareparts: jenisParts.value,
                supplier: selectedSupplier.value,
                kualiti: selectedKualitiParts.value,
                maklumatSpareparts: maklumatParts.value,
                tarikh: DateTime.now().millisecondsSinceEpoch.toString(),
                harga: hargaParts.value,
                partsID: id,
              );
              Get.dialog(
                const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
              try {
                await FirebaseDatabase.instance
                    .ref()
                    .child('Spareparts')
                    .child(id)
                    .update(spareparts.toJson());

                await _sparepartsController.refreshDialog(false);
                setArguments();
                editMode.value = false;
                Get.back();
                Get.back();
                Get.back();
                ShowSnackbar.success('Kemaskini Spareparts',
                    'Spareparts anda telah dikemaskini', false);
              } on Exception catch (e) {
                Get.back();
                Get.back();
                Get.back();
                ShowSnackbar.error('Gagal untuk mengemaskini spareparts',
                    'Kesalahan telah berlaku: $e', false);
              }
            },
            child: const Text('Simpan perubahan'),
          ),
        ],
      ));
    } else {
      editMode.value = false;
    }
  }

  Future<void> deleteSpareparts(String id, String model, String jenis) async {
    Haptic.feedbackError();
    Get.dialog(AlertDialog(
      title: const Text('Adakah anda pasti?'),
      content:
          Text('Adakah anda pasti untuk membuang sparepart $jenis $model?'),
      actions: [
        TextButton(
          onPressed: () async {
            Get.dialog(
              const AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
            await FirebaseDatabase.instance
                .ref()
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
          child: const Text('Batal'),
        ),
      ],
    ));
  }

  void editJenisSpareparts() {
    if (editMode.value == true) {
      Get.dialog(
        AlertDialog(
          title: const Text('Sunting Jenis Spareparts'),
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
              child: const Text('Batal'),
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
              child: const Text('Simpan'),
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
          title: const Text('Sunting Model Smartphone'),
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
              child: const Text('Batal'),
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
              child: const Text('Simpan'),
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
          title: const Text('Sunting Maklumat Spareparts'),
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
              child: const Text('Batal'),
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
              child: const Text('Simpan'),
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
          title: const Text('Sunting Harga Spareparts'),
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
              child: const Text('Batal'),
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
              child: const Text('Simpan'),
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
          title: const Text('Sunting Kualiti Spareparts'),
          content: Obx(() {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? Colors.grey.shade900
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10)),
              child: DropdownButton(
                icon: const SizedBox(),
                underline: const SizedBox(),
                items: Inventory.quality.map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(
                      value.toString(),
                    ),
                  );
                }).toList(),
                value: selectedKualitiParts.value,
                onChanged: (String? newValue) {
                  selectedKualitiParts.value = newValue.toString();
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
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Simpan'),
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
          title: const Text('Sunting Supplier'),
          content: Obx(() {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? Colors.grey.shade900
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10)),
              child: DropdownButton(
                icon: const SizedBox(),
                underline: const SizedBox(),
                items: Inventory.supplier.map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(
                      Inventory.getSupplierCode(
                        value.toString(),
                      ),
                    ),
                  );
                }).toList(),
                value: selectedSupplier.value,
                onChanged: (String? newValue) {
                  selectedSupplier.value = newValue.toString();
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
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Simpan'),
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
}
