import 'package:admin_panel/jobsheet/controller/jobsheet_controller.dart';
import 'package:admin_panel/jobsheet/model/jobsheet_history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobsheetHistoryController extends GetxController {
  final _jobsheetController = Get.find<JobsheetController>();

  void delete(int id) {
    Get.dialog(
      AlertDialog(
        title: const Text('Adakah anda pasti'),
        content: const Text('Adakah anda pasti untuk membuang item ini?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              // await DatabaseHelper.instance.deleteCustomerHistory(id);
              Get.back();
              Get.back();
              update();
            },
            child: const Text(
              'Buang',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void getToJobsheet(JobsheetHistoryModel history) {
    _jobsheetController.namaCust.text = history.name;
    _jobsheetController.email.text = history.email;
    _jobsheetController.harga.text = history.price;
    _jobsheetController.kerosakkan.text = history.kerosakkan;
    _jobsheetController.noPhone.text = history.noPhone;
    _jobsheetController.modelPhone.text = history.model;
    _jobsheetController.remarks.text = history.remarks;
    _jobsheetController.passPhone.text = history.password;
    _jobsheetController.mySID.value = history.userUID;
    Get.back();
    Get.back();
  }

  void showDetails(JobsheetHistoryModel history) {
    Get.dialog(
      AlertDialog(
        title: const Text('Maklumat Sejarah Jobsheet'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Nama Customer: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(history.name == '' ? '--' : history.name),
              const SizedBox(height: 10),
              const Text(
                'Nombor untuk dihubungi: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(history.noPhone == '' ? '--' : history.noPhone),
              const SizedBox(height: 10),
              const Text(
                'Email: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(history.email == '' ? '--' : history.email),
              const SizedBox(height: 10),
              const Text(
                'Model Smartphone: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(history.model == '' ? '--' : history.model),
              const SizedBox(height: 10),
              const Text(
                'Password: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(history.password == '' ? '--' : history.password),
              const SizedBox(height: 10),
              const Text(
                'Kerosakkan: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(history.kerosakkan == '' ? '--' : history.kerosakkan),
              const SizedBox(height: 10),
              const Text(
                'Anggaran Harga: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(history.price == '' ? '--' : history.price),
              const SizedBox(height: 10),
              const Text(
                'Remarks: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(history.remarks == '' ? '--' : history.remarks),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => delete(history.id!.toInt()),
            child: const Text(
              'Buang',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          TextButton(
            onPressed: () => getToJobsheet(history),
            child: const Text('Tambah ke Jobsheet'),
          ),
        ],
      ),
    );
  }
}
