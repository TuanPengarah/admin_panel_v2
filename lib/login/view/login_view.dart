import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/API/firebaseAuth_controller.dart';
import 'package:admin_panel/config/theme_data.dart';
import 'package:admin_panel/login/controller/show_password.dart';
import 'package:admin_panel/login/view/login_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoginView extends StatelessWidget {
  final _loginController = Get.put(AuthController());
  final _visibilityPassword = Get.put(ShowPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      Get.isDarkMode
                          ? 'assets/images/splash_light.png'
                          : 'assets/images/splash_dark.png',
                      scale: 8,
                    ),
                    IconButton(
                      icon: Icon(Icons.dark_mode,
                          color: Get.isDarkMode
                              ? Colors.amber
                              : Theme.of(context).primaryColor),
                      onPressed: MyThemes().switchTheme,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Lottie.asset(
                    'assets/lottie/lottie_login.json',
                    height: 500,
                    width: 500,
                  ),
                  Text(
                    'Admin Panel',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      letterSpacing: 1.3,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Urus segala maklumat dan data pelanggan yang telah atau masih dibaiki di Af-Fix Smartphone Repair!',
                    textAlign: TextAlign.center,
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
                        'Mula Sekarang!',
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
