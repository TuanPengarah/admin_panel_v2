import 'dart:io';
import 'dart:typed_data';
import 'package:admin_panel/config/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../../config/routes.dart';

class ControllerCreatePost extends GetxController {
  final key = GlobalKey<FormState>();
  final TextEditingController modelPhoneText = TextEditingController();
  final TextEditingController repairText = TextEditingController();
  final TextEditingController jenisGambarText = TextEditingController();
  final WidgetsToImageController screenController = WidgetsToImageController();
  Uint8List? image;
  File imageLocation = File('');
  String? imageName;
  String jenisGambar = 'Biasa';
  List<String> masalah = [];
  List<TextEditingController> masalahController = [];

  @override
  void onInit() {
    super.onInit();

    addMasalah();
    jenisGambarText.text = jenisGambar;
  }

  void chooseType() {
    Get.dialog(
      AlertDialog(
        icon: const Icon(Icons.image),
        title: const Text('Pilih jenis gambar'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Biasa'),
              onTap: () {
                jenisGambar = 'Biasa';
                jenisGambarText.text = jenisGambar;
                Get.back();
                update();
              },
            ),
            ListTile(
              title: const Text('Next -->'),
              onTap: () {
                jenisGambar = 'Next';
                jenisGambarText.text = '$jenisGambar -->';
                Get.back();
                update();
              },
            ),
            ListTile(
              title: const Text('Done ✓'),
              onTap: () {
                jenisGambar = 'Done';
                jenisGambarText.text = '$jenisGambar ✓';
                Get.back();
                update();
              },
            ),
          ],
        ),
      ),
    );
  }

  void uploadImage() async {
    final fileImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (fileImage == null) {
      ShowSnackbar.error('Kesalahan telah berlaku',
          'Sila masukkan gambar peranti yang telah dibaiki', false);
      return;
    }
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: fileImage.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedImage != null) {
      imageLocation = File(croppedImage.path);
      imageName = fileImage.name;
      update();
    }
  }

  void generateImage() {
    if (key.currentState!.validate()) {
      if (imageLocation.path.isEmpty) {
        Get.dialog(
          AlertDialog(
            icon: const Icon(Icons.image),
            title: const Text('Gambar nye mana?'),
            content: const Text('Sila masukkan gambar peranti yang dibaiki'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                  uploadImage();
                },
                child: const Text('Tambah Gambar'),
              ),
            ],
          ),
        );
      } else {
        Get.toNamed(MyRoutes.resultPost);
      }
    }
  }

  void addMasalah() {
    masalah.add('');
    for (int i = 0; i < masalah.length; i++) {
      masalahController.add(TextEditingController());
      masalahController[i].text = masalah[i];
    }
    update();
  }

  void removeMasalah(int index) {
    masalah.removeAt(index);
    masalahController.removeAt(index);
    update();
  }

  void savePost() async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/post.png');

    image = await screenController.capture();

    if (image != null) {
      final resultFile = await file.writeAsBytes(image!);
      await GallerySaver.saveImage(resultFile.path);
      Share.shareXFiles(
        [XFile(resultFile.path)],
      );
    }
  }
}
