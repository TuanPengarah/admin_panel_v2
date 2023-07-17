import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:admin_panel/config/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../../config/routes.dart';
import '../model/history_post.dart';

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

  void deleteHistory(Box box, List keys, int i) {
    box.delete(keys[i]);
    update();
  }

  void pickHistory(HistoryPost sejarah) {
    imageLocation = File(sejarah.path);

    jenisGambarText.text = sejarah.jenisGambar;
    imageName = sejarah.imageName;
    masalah = sejarah.masalah.where((e) => e.isNotEmpty).toList();

    modelPhoneText.text = sejarah.model;
    repairText.text = sejarah.repair;

    for (int i = 0; i < masalah.length; i++) {
      masalahController.add(TextEditingController());
      masalahController[i].text = masalah[i];
    }
    Get.back();

    update();
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
    Get.dialog(
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [CircularProgressIndicator.adaptive()],
          ),
        ),
      ),
    );
    final fileImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (fileImage == null) {
      ShowSnackbar.error('Kesalahan telah berlaku',
          'Sila masukkan gambar peranti yang telah dibaiki', false);
      Get.back();
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
      Get.back();
    } else {
      Get.back();
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
    Get.dialog(
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Menghasilkan gambar...'),
              SizedBox(height: 5),
              CircularProgressIndicator.adaptive(),
            ],
          ),
        ),
      ),
    );
    final data = HistoryPost(
      path: imageLocation.path,
      imageName: imageName.toString(),
      jenisGambar: jenisGambarText.text,
      model: modelPhoneText.text,
      repair: repairText.text,
      masalah: masalah,
    ).toDB();
    await Hive.openBox('historyPost');
    await Hive.box('historyPost').add(data);
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/post.png');

    image = await screenController.capture();

    if (image != null) {
      final resultFile = await file.writeAsBytes(image!);
      await GallerySaver.saveImage(resultFile.path);
      Share.shareXFiles(
        [XFile(resultFile.path)],
      );
      Get.back();
    } else {
      Get.back();
    }
  }
}
