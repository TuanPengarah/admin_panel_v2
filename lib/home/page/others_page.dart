import 'package:admin_panel/auth/controller/firebaseAuth_controller.dart';
import 'package:admin_panel/config/theme_data.dart';
import 'package:admin_panel/home/controller/other_controller.dart';
import 'package:admin_panel/home/widget/other_setting.dart';
import 'package:admin_panel/home/widget/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

class SettingPage extends StatelessWidget {
  final _otherController = Get.put(OtherController());
  final _authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
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
            IconButton(
              icon: Icon(Icons.dark_mode,
                  color: Get.isDarkMode ? Colors.amber : Colors.black),
              onPressed: MyThemes().switchTheme,
            ),
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
    ));
  }
}
// Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'POS',
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               _authController.performLogOut();
//             },
//             icon: Icon(Icons.logout),
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.dark_mode,
//               color: Colors.white,
//             ),
//             onPressed: MyThemes().switchTheme,
//           ),
//         ],
//       ),
//       body: SizedBox(
//         width: Get.width,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 final technicians = Technician('Akid Fikri Azhar', 'Kajang',
//                     _authController.userEmail, 44, 1084);
//                 CrudTechnician.createTechnician(
//                     _authController.userUID, technicians);
//               },
//               child: Text('Tambah technicians'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 print(_authController.userUID);
//                 CrudTechnician.readTechnician(_authController.userUID);
//               },
//               child: Text('Baca Technician'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 print(_authController.userName);
//                 print(_authController.userUID);
//                 print(_authController.userEmail);
//                 print(_authController.jumlahKeuntungan);
//                 print(_authController.jumlahRepair);
//               },
//               child: Text('Check Technician'),
//             ),
//           ],
//         ),
//       ),
//     );
