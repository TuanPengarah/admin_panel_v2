import 'dart:math';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/API/firebaseAuth_controller.dart';
import 'package:admin_panel/login/controller/show_password.dart';
import 'package:admin_panel/login/view/login_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  final _random = new Random();
  final _loginController = Get.put(AuthController());
  final _visibilityPassword = Get.put(ShowPasswordController());
  int _getRandom(int min, int max) => min + _random.nextInt(max - min);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login${_getRandom(0, 3)}.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black87,
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0, 1.5, 0.2, 0.2],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/images/splash_light.png',
                    scale: 6,
                  ),
                  Text(
                    'Admin Panel',
                    style: TextStyle(
                      fontSize: 23,
                      letterSpacing: 1.3,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Urus segala maklumat dan data pelanggan yang telah atau masih dibaiki di Af-Fix Smartphone Repair!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        Haptic.feedbackClick();
                        ShowBottomSheet.showLoginSheet(
                            context, _loginController, _visibilityPassword);
                      },
                      child: Text(
                        'Log Masuk',
                      ),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
