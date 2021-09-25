import 'package:admin_panel/home/widget/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TechnicianInfo extends StatelessWidget {
  final _data = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment : CrossAxisAlignment.center,
          children: [
            ProfileAvatar().profile(
              context: context,
              name: _data['name'],
              photoURL: _data['photoURL'],
              email: _data['email'],
              jawatan: _data['jawatan'],
            ),
            SizedBox(height: 30),
            ProfileAvatar().yourRecord(context, _data['jumlahRepair'], _data['jumlahKeuntungan'], false,),
          ],
        ),
      ),
    );
  }
}
