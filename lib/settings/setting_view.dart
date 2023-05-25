import 'package:admin_panel/home/controller/other_controller.dart';
import 'package:admin_panel/home/widget/other_setting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewSettings extends StatelessWidget {
  final _otherController = Get.put(OtherController());

  ViewSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Tetapan'),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
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
    );
  }
}
