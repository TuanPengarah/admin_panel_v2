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
            AdvancedAvatar(
              size: 120,
              name: _authController.userName,
              style: TextStyle(fontSize: 50),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(200),
              ),
            ),
            SizedBox(height: 20),
            Text(
              _authController.userName.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Sr. Technician | Founder',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(_authController.userEmail.toString(),
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                )),
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
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.handyman_outlined,
                          color: Colors.grey,
                          size: 40,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Jumlah Repair',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '${_authController.jumlahRepair.value}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
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
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.toll_outlined,
                          color: Colors.grey,
                          size: 40,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Jumlah Keuntunggan',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'RM${_authController.jumlahKeuntungan.value}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
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
