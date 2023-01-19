import 'package:admin_panel/home/controller/other_controller.dart';
import 'package:admin_panel/home/widget/other_setting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewSettings extends StatelessWidget {
  ViewSettings({Key key}) : super(key: key);
  final _otherController = Get.put(OtherController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text('Tetapan'),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                OtherSettings(),
                SizedBox(height: 40),
                OtherSettings().logOutButton(),
                SizedBox(height: 40),
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
    );
  }
}
