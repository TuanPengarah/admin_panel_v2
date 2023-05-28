import 'package:admin_panel/auth/controller/firebase_auth_controller.dart';
import 'package:admin_panel/home/controller/other_controller.dart';
import 'package:admin_panel/home/widget/other_setting.dart';
import 'package:admin_panel/home/widget/profile_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingPage extends StatelessWidget {
  final _otherController = Get.find<OtherController>();
  final _authController = Get.find<AuthController>();

  SettingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () async {
        await _authController.checkUserData(
          FirebaseAuth.instance.currentUser!.email.toString(),
        );
      },
      child: CustomScrollView(
        primary: false,
        slivers: [
          SliverAppBar(
            snap: false,
            pinned: false,
            floating: false,
            expandedHeight: Get.mediaQuery.size.width >= 640 ? 180 : 290,
            flexibleSpace: FlexibleSpaceBar(
              background: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Obx(
                      () => ProfileAvatar(
                        email: _authController.userEmail.value,
                        jawatan: _authController.jawatan.value,
                        name: _authController.userName.value,
                        photoURL: _authController.photoURL.value,
                        cawangan: _authController.cawangan.value,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            // systemOverlayStyle: Theme.of(context).brightness == Brightness.light
            //     ? SystemUiOverlayStyle.dark
            //     : SystemUiOverlayStyle.light,
            // elevation: 0,

            // actions: [
            //   Obx(() => TextButton.icon(
            //         onPressed: () => Haptic.feedbackClick(),
            //         icon: Icon(Icons.place),
            //         label: Text(_authController.cawangan.value.toString()),
            //       ))
            // ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Obx(
                  () => YourRecord(
                    jumlahKeuntungan: _authController.jumlahKeuntungan.value,
                    isMy: true,
                    jumlahRepair: _authController.jumlahRepair.value,
                  ),
                ),
                const SizedBox(height: 30),
                OtherSettings(),
                const SizedBox(height: 40),
                OtherSettings().logOutButton(),
                const SizedBox(height: 40),
                Icon(
                    GetPlatform.isIOS
                        ? Icons.apple
                        : GetPlatform.isAndroid
                            ? Icons.android
                            : Icons.web,
                    color: Colors.grey),
                Obx(() {
                  return Text(
                    'Af-Fix Admin Panel V2.0\n- ${_otherController.deviceModel.value} -\nDibangunkan oleh Akid Fikri Azhar',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  );
                }),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
