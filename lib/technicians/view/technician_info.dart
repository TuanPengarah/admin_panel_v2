import 'package:admin_panel/auth/controller/firebaseAuth_controller.dart';
import 'package:admin_panel/home/widget/profile_avatar.dart';
import 'package:admin_panel/technicians/controller/technician_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/routes.dart';

class TechnicianInfo extends StatelessWidget {
  final _data = Get.arguments;
  final _params = Get.parameters;
  final _controller = Get.find<TechnicianController>();
  final _authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Get.isDarkMode ? Colors.white : Colors.black,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          _authController.jawatan.value.contains('Founder')
              ? IconButton(
                  tooltip: 'Buang Juruteknik',
                  onPressed: () => _controller.deleteTechnician(
                      _data['photoURL'], _data['id'], _data['name']),
                  icon: Icon(Icons.delete),
                )
              : const SizedBox(),
          _authController.userName.value != _data['name']
              ? IconButton(
                  tooltip: 'Hantar Mesej',
                  onPressed: () => Get.toNamed(
                    MyRoutes.chat,
                    arguments: {
                      'photoURL': _data['photoURL'],
                      'photoURL1': _data['photoURL1'],
                      'name': _data['name'],
                      'token': _data['token'],
                      'userToken': _authController.token,
                      'uid': _data['uid']
                    },
                    parameters: {
                      'id': _params['id'],
                    },
                  ),
                  icon: const Icon(Icons.send),
                )
              : const SizedBox(),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
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
              SizedBox(height: 30),
              TextButton(
                child: Text('Token Peranti (FCM)'),
                onPressed: () => Get.dialog(AlertDialog(
                  content: SelectableText('${_data['token']}'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text('Tutup'),
                    ),
                  ],
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
