import 'package:admin_panel/auth/controller/firebaseAuth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:get/get.dart';

class ProfileAvatar {
  final _authController = Get.find<AuthController>();
  Container profile(BuildContext context) {
    return Container(
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() => AdvancedAvatar(
                  size: 120,
                  name: _authController.userName.value,
                  style: TextStyle(fontSize: 50),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(200),
                  ),
                )),
            SizedBox(height: 20),
            Obx(() => Text(
                  _authController.userName.value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                )),
            SizedBox(height: 8),
            Text(
              'Sr. Technician | Founder',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Obx(() => Text(_authController.userEmail.value,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ))),
          ],
        ),
      ),
    );
  }

  Padding yourRecord(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 5),
            child: Text(
              'Rekod Anda',
              style: TextStyle(
                fontSize: 18,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade900
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.handyman_outlined,
                          color: Theme.of(context).primaryColor,
                          size: 40,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Jumlah Repair',
                          style: TextStyle(
                            color: Get.isDarkMode
                                ? Colors.grey.shade300
                                : Colors.grey.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Obx(() {
                          return Text(
                            '${_authController.jumlahRepair.value}',
                            style: TextStyle(
                              color: Get.isDarkMode
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade700,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade900
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.toll_outlined,
                          color: Theme.of(context).primaryColor,
                          size: 40,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Jumlah Keuntunggan',
                          style: TextStyle(
                            color: Get.isDarkMode
                                ? Colors.grey.shade300
                                : Colors.grey.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Obx(() {
                          return Text(
                            'RM${_authController.jumlahKeuntungan.value}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Get.isDarkMode
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade700,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
