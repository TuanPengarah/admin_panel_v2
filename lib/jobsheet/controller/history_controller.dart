import 'package:admin_panel/API/sqlite.dart';
import 'package:admin_panel/jobsheet/controller/jobsheet_controller.dart';
import 'package:admin_panel/jobsheet/model/jobsheet_history.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  final _jobsheetController = Get.find<JobsheetController>();

  void delete(int id) {
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
              await DatabaseHelper.instance.delete(id);
              Get.back();
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
        title: Text('Maklumat Sejarah Jobsheet'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Nama Customer: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(history.name == '' ? '--' : history.name),
              SizedBox(height: 10),
              Text(
                'Nombor untuk dihubungi: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(history.noPhone == '' ? '--' : history.noPhone),
              SizedBox(height: 10),
              Text(
                'Email: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(history.email == '' ? '--' : history.email),
              SizedBox(height: 10),
              Text(
                'Model Smartphone: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(history.model == '' ? '--' : history.model),
              SizedBox(height: 10),
              Text(
                'Password: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(history.password == '' ? '--' : history.password),
              SizedBox(height: 10),
              Text(
                'Kerosakkan: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(history.kerosakkan == '' ? '--' : history.kerosakkan),
              SizedBox(height: 10),
              Text(
                'Anggaran Harga: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(history.price == '' ? '--' : history.price),
              SizedBox(height: 10),
              Text(
                'Remarks: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(history.remarks == '' ? '--' : history.remarks),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => delete(history.id),
            child: Text(
              'Buang',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          TextButton(
            onPressed: () => getToJobsheet(history),
            child: Text('Tambah ke Jobsheet'),
          ),
        ],
      ),
    );
  }
}
