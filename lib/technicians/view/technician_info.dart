import 'package:admin_panel/home/widget/profile_avatar.dart';
import 'package:admin_panel/technicians/controller/technician_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TechnicianInfo extends StatelessWidget {
  final _data = Get.arguments;
  final _controller = Get.find<TechnicianController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Get.isDarkMode ? Colors.white : Colors.black,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _controller.deleteTechnician(_data['photoURL'], _data['id'], _data['name']),
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfileAvatar().profile(
              context: context,
              name: _data['name'],
              photoURL: _data['photoURL'],
              email: _data['email'],
              jawatan: _data['jawatan'],
            ),
            SizedBox(height: 30),
            ProfileAvatar().yourRecord(
              context,
              _data['jumlahRepair'],
              _data['jumlahKeuntungan'],
              false,
            ),
          ],
        ),
      ),
    );
  }
}
