import 'dart:io';

import 'package:admin_panel/auth/model/technician_model.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class TechnicianAddController extends GetxController {
  // final _staffController = Get.find<TechnicianController>();

  var currentSteps = 0.obs;

  final namaStaff = TextEditingController();
  final emailStaff = TextEditingController();

  final staffFocus = FocusNode();
  final emailFocus = FocusNode();

  var errStaff = false.obs;
  var errEmail = false.obs;

  var selectedJawatan = 'Technician'.obs;
  var selectedCawangan = 'Kajang'.obs;

  static const staffPassword = '123456';

  File imageFile = File('');

  Future<void> addToDatabase() async {
    var status = 'Memuat data...'.obs;
    String uid = '';
    String photoURL = '';
    Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 30),
            const Text(
              'Menambah Staff ke pangkalan data...',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Obx(
              () => Text(
                'Status: $status',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
    Haptic.feedbackClick();
    FirebaseApp app = await Firebase.initializeApp(
      name: 'Secondary',
      options: Firebase.app().options,
    );
    try {
      status.value = 'Mencipta akaun staff...';
      await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(
              email: emailStaff.text, password: staffPassword)
          .then((credential) async {
        status.value = 'Mencipta akaun selesai! UID: ${credential.user!.uid}';
        uid = credential.user!.uid.toString();
        status.value = 'Memuat naik gambar staff...';
        final destination =
            'technicians/photoURL/${namaStaff.text.toLowerCase().replaceAll(' ', '')}.jpg';
        final ref = FirebaseStorage.instance.ref(destination);
        await ref
            .putFile(imageFile)
            .then((p0) async => photoURL = await p0.ref.getDownloadURL());
        status.value = 'Memuat naik gambar selesai!';
        await Future.delayed(const Duration(seconds: 1));
        status.value = 'Mencipta data staff ke server...!';
        final String? token = await FirebaseMessaging.instance.getToken();
        await FirebaseDatabase.instance
            .ref()
            .child('Technician')
            .child(uid)
            .set(Technician(
              id: uid,
              nama: namaStaff.text,
              cawangan: selectedCawangan.value,
              email: emailStaff.text,
              jumlahRepair: 0,
              jumlahKeuntungan: 0,
              jawatan: selectedJawatan.value,
              photoURL: photoURL,
              token: token,
            ).toJson())
            .then((value) => status.value = 'Selesai!');
        await Future.delayed(const Duration(seconds: 1));
        app.delete();
        // await _staffController.getTechnician();
        Haptic.feedbackSuccess();
        Get.back();
        Get.back();
        ShowSnackbar.success('Tambah Staff',
            'Tahniah penambahan staff ke server selesai', false);
      });
    } on Exception catch (e) {
      await Future.delayed(const Duration(seconds: 1));
      app.delete();
      ShowSnackbar.error(
          'Tambah Staff',
          'Kesalahan telah berlaku apabila menambah staff ker server: $e',
          false);
      Haptic.feedbackError();
      Get.back();
    }
  }

  void nextStepper() async {
    Haptic.feedbackClick();
    String generateEmail = '';
    if (currentSteps.value == 0) {
      if (namaStaff.text.isEmpty) {
        Haptic.feedbackError();
        errStaff.value = true;
      } else {
        currentSteps.value++;
        errStaff.value = false;
        staffFocus.unfocus();
        generateEmail =
            '${namaStaff.text.toLowerCase().replaceAll(' ', '')}@assaff.com';
        emailStaff.text = generateEmail;
      }
    } else if (currentSteps.value == 1) {
      currentSteps.value++;
    } else if (currentSteps.value == 2) {
      currentSteps.value++;
      await Future.delayed(const Duration(milliseconds: 300));
      emailFocus.requestFocus();
    } else if (currentSteps.value == 3) {
      if (emailStaff.text.isEmpty) {
        errEmail.value = true;
        Haptic.feedbackError();
      } else {
        currentSteps.value++;
        emailFocus.unfocus();
      }
    } else if (currentSteps.value == 4) {
      currentSteps.value++;
    } else if (currentSteps.value == 5) {
      addToDatabase();
    }
  }

  void backStepper() {
    Haptic.feedbackError();
    Get.focusScope!.unfocus();
    currentSteps.value -= 1;
  }

  void choosePictureDialog() {
    Haptic.feedbackClick();
    Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Ambil gambar dari kamera'),
              onTap: () async {
                Haptic.feedbackClick();
                final file = await _pickImage(
                    source: ImageSource.camera, cropImage: _cropSquareImage);
                if (file!.path.isEmpty) return;

                final fileRaw = File(file.path);
                imageFile = fileRaw;
                Get.back();
                update();
              },
            ),
            ListTile(
              title: const Text('Ambil dari galeri'),
              onTap: () async {
                Haptic.feedbackClick();
                final file = await _pickImage(
                    source: ImageSource.gallery, cropImage: _cropSquareImage);
                if (file == null) return;
                final fileRaw = File(file.path);
                imageFile = fileRaw;
                Get.back();
                update();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<CroppedFile?> _cropSquareImage(CroppedFile? imageFile) async =>
      await ImageCropper().cropImage(
        sourcePath: imageFile!.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square
        ],
        compressQuality: 70,
        compressFormat: ImageCompressFormat.jpg,
        // androidUiSettings: _androidUiCrop(),
        uiSettings: [
          _androidUiCrop(),
        ],
      );

  AndroidUiSettings _androidUiCrop() => AndroidUiSettings(
        toolbarTitle: 'Sunting Gambar',
        toolbarColor: Get.theme.primaryColor,
        toolbarWidgetColor: Colors.white,
      );

  Future<CroppedFile?> _pickImage(
      {required ImageSource source,
      required Future<CroppedFile?> Function(CroppedFile? file)
          cropImage}) async {
    final pickImage = await ImagePicker().pickImage(source: source);

    if (pickImage == null) return null;

    final file = CroppedFile(pickImage.path);

    return cropImage(file);
  }

  void removePicture() {
    Haptic.feedbackError();
    imageFile = File('');
    update();
  }
}
