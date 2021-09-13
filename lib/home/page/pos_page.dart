import 'package:admin_panel/auth/controller/firebaseAuth_controller.dart';
import 'package:admin_panel/auth/model/crud_technician.dart';
import 'package:admin_panel/auth/model/technician_model.dart';
import 'package:admin_panel/config/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingPage extends StatelessWidget {
  final _authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'POS',
        ),
        actions: [
          IconButton(
            onPressed: () {
              _authController.performLogOut();
            },
            icon: Icon(Icons.logout),
          ),
          IconButton(
            icon: Icon(
              Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: MyThemes().switchTheme,
          ),
        ],
      ),
      body: SizedBox(
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                final technician = Technician('Akid Fikri Azhar', 'Kajang',
                    _authController.userEmail, 44, 1084);
                CrudTechnician.createTechnician(
                    _authController.userUID, technician);
              },
              child: Text('Tambah technician'),
            ),
            ElevatedButton(
              onPressed: () {
                print(_authController.userUID);
                CrudTechnician.readTechnician(_authController.userUID);
              },
              child: Text('Baca Technician'),
            ),
            ElevatedButton(
              onPressed: () {
                CrudTechnician.checkTechnician(_authController.userUID);
              },
              child: Text('Check Technician'),
            ),
          ],
        ),
      ),
    );
  }
}
