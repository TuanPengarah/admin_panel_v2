import 'package:admin_panel/config/theme_data.dart';
import 'package:admin_panel/home/controller/other_controller.dart';
import 'package:admin_panel/home/widget/other_setting.dart';
import 'package:admin_panel/home/widget/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

class SettingPage extends StatelessWidget {
  final _otherController = Get.put(OtherController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          brightness: Theme.of(context).brightness == Brightness.light
              ? Brightness.light
              : Brightness.dark,
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
              ProfileAvatar().profile(context),
              SizedBox(height: 30),
              ProfileAvatar().yourRecord(context),
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
//                 final technician = Technician('Akid Fikri Azhar', 'Kajang',
//                     _authController.userEmail, 44, 1084);
//                 CrudTechnician.createTechnician(
//                     _authController.userUID, technician);
//               },
//               child: Text('Tambah technician'),
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