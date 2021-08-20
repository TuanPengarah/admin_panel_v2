import 'package:admin_panel/API/firebaseAuth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  final _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Dashboard',
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _authController.performLogOut();
              },
            ),
          ]),
    );
  }
}
