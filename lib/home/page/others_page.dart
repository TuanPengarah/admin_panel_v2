import 'package:admin_panel/auth/controller/firebaseAuth_controller.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/home/controller/other_controller.dart';
import 'package:admin_panel/home/widget/other_setting.dart';
import 'package:admin_panel/home/widget/profile_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

class SettingPage extends StatelessWidget {
  final _otherController = Get.find<OtherController>();
  final _authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () async {
        await _authController.checkUserData(
          FirebaseAuth.instance.currentUser.email,
        );
      },
      child: CustomScrollView(
        primary: false,
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            systemOverlayStyle: Theme.of(context).brightness == Brightness.light
                ? SystemUiOverlayStyle.dark
                : SystemUiOverlayStyle.light,
            elevation: 0,
            snap: false,
            pinned: false,
            floating: false,
            actions: [
              TextButton.icon(
                onPressed: () => Haptic.feedbackClick(),
                icon: Icon(Icons.place),
                label: Text(_authController.cawangan.value.toString()),
              )
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Obx(
                  () => ProfileAvatar().profile(
                    email: _authController.userEmail.value,
                    name: _authController.userName.value,
                    jawatan: _authController.jawatan.value,
                    context: context,
                    photoURL: _authController.photoURL.value,
                  ),
                ),
                SizedBox(height: 30),
                Obx(
                  () => ProfileAvatar().yourRecord(
                    context,
                    _authController.jumlahRepair.value,
                    _authController.jumlahKeuntungan.value,
                    true,
                  ),
                ),
                SizedBox(height: 30),
                OtherSettings().otherAndSetting(context),
                SizedBox(height: 40),
                OtherSettings().logOutButton(),
                SizedBox(height: 40),
                Icon(
                    GetPlatform.isIOS
                        ? LineIcons.apple
                        : GetPlatform.isAndroid
                            ? LineIcons.android
                            : LineIcons.tablet,
                    color: Colors.grey),
                Obx(() {
                  return Text(
                    'Af-Fix Admin Panel V2.0\n- ${_otherController.deviceModel.value} -\nDibangunkan oleh Akid Fikri Azhar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  );
                }),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
