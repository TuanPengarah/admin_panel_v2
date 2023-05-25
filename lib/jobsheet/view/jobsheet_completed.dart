import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/jobsheet/controller/jobsheet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class JobsheetCompleted extends StatelessWidget {
  final _jobsheetController = Get.find<JobsheetController>();
  final _data = Get.parameters;

  JobsheetCompleted({super.key});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.bottomCenter,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Lottie.asset(
                    'assets/lottie/lottie_jobsheet_confirm.json',
                    height: 350,
                    width: 350,
                  ),
                  Obx(() => Text(
                        _jobsheetController.errFirestore.value == true
                            ? 'Jobsheet untuk pelanggan ini telah berjaya di buka tetapi gagal untuk memasukan ke Server Pelanggan. Sila cuba sebentar lagi!'
                            : 'Tahniah! Jobsheet untuk pelanggan ini telah berjaya di buka dan telah dimasukkan di Server Pelanggan',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 50,
                    child: ElevatedButton.icon(
                        icon: const Icon(Icons.share),
                        onPressed: () =>
                            _jobsheetController.showShareJobsheet(_data),
                        label: const Text('Hasilkan maklumat Jobsheet')),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Haptic.feedbackSuccess();
                      Get.offAllNamed(MyRoutes.home);
                    },
                    child: const Text('Tutup'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
