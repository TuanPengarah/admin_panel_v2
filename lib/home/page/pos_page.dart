import 'package:admin_panel/API/firebaseAuth_controller.dart';
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
          )
        ],
      ),
    );
  }
}
