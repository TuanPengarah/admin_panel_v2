import 'package:admin_panel/config/snackbar.dart';
import 'package:admin_panel/sms/controller/sms_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/haptic_feedback.dart';

class SMSView extends GetView<SMSController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS Gateway'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.dialog(
            AlertDialog(
              title: const Text('Adakah anda pasti'),
              content: const Text(
                'Pastikan penerima dan mesej yang ingin dihantar adalah betul!',
              ),
              actions: [
                TextButton(
                  onPressed: controller.getBack,
                  child: Text(
                    'Batal',
                    style: TextStyle(color: Colors.amber[900]),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (controller.isReady() == true) {
                      Get.back();
                      Haptic.feedbackClick();
                      Get.dialog(
                        AlertDialog(
                          title: const Text('Menghantar mesej...'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                            ],
                          ),
                        ),
                      );
                      await controller.sendSMS().then((value) {
                        if (value == 'Low credits') {
                          Get.back();
                          ShowSnackbar.error(
                              'Kesalahan telah berlaku!',
                              'Kredit anda tidak mencukupi! Sila isi semula kredit anda di website sms.ala.my',
                              true);
                        } else {
                          Get.back();
                          ShowSnackbar.success('Operasi Selesai!',
                              'SMS telah dihantar kepada!', true);
                        }
                      });
                    } else {
                      Get.back();
                      Haptic.feedbackError();
                      ShowSnackbar.error('Kesalahan telah berlaku!',
                          'Pastikan anda telah masukkan semua maklumat', true);
                    }
                  },
                  child: const Text('Pasti'),
                ),
              ],
            ),
          );
        },
        label: const Text('Hantar'),
        icon: const Icon(Icons.send),
        backgroundColor: Get.theme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: TextField(
              controller: controller.recipientText,
              decoration: InputDecoration(
                label: const Text('Penerima'),
                hintText: 'Letak koma jika ingin hantar penerima yang lain',
                hintStyle: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.people),
              label: const Text('Pilih dari pelanggan'),
              onPressed: controller.getCustomer,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: controller.messageText,
              maxLines: 10,
              decoration: InputDecoration(
                label: const Text('Mesej'),
                hintText: 'Sila masukkan mesej anda!',
                hintStyle: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 60),
          Container(
            alignment: Alignment.center,
            child: const Text(
              'PERINGATAN: Kadar untuk hantar SMS adalah berbayar!\nKadar SMS adalah RM 0.0075 per SMS',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            alignment: Alignment.center,
            child: GestureDetector(
              child: Text(
                'https://sms.ala.my',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Get.theme.primaryColor,
                ),
              ),
              onTap: () => launch('https://sms.ala.my'),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
