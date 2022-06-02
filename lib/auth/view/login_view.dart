import 'package:admin_panel/auth/controller/firebaseAuth_controller.dart';
import 'package:admin_panel/auth/view/login_dialog.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoginView extends StatelessWidget {
  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.dark_mode,
              color:
                  Get.isDarkMode ? Colors.amber : Get.theme.colorScheme.primary,
            ),
            onPressed: MyThemes().switchTheme,
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Lottie.asset(
                      'assets/lottie/lottie_login.json',
                      width: 300,
                      height: 300,
                    ),
                  ),
                  ShaderMask(
                    child: SizedBox(
                        width: 55.0,
                        height: 55.0,
                        child: Image(
                          image: AssetImage(
                            'assets/images/splash_light.png',
                          ),
                        )),
                    shaderCallback: ((bounds) => LinearGradient(
                          colors: [
                            Get.theme.colorScheme.primary,
                            Get.theme.colorScheme.primary
                          ],
                          stops: [
                            0.0,
                            0.0,
                          ],
                        ).createShader(bounds)),
                    blendMode: BlendMode.srcATop,
                  ),
                  // Image.asset(
                  //   Get.isDarkMode
                  //       ? 'assets/images/splash_light.png'
                  //       : 'assets/images/splash_dark.png',
                  //   scale: 7,
                  // ),
                  SizedBox(height: 2),
                  Text(
                    'Admin Panel',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      letterSpacing: 1.3,
                      fontWeight: FontWeight.bold,
                      color: Get.theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Urus segala maklumat dan data pelanggan yang telah atau masih dibaiki di Af-Fix Smartphone Repair!',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        Haptic.feedbackClick();
                        ShowBottomSheet.showLoginSheet(
                            context, _authController);
                      },
                      child: Text(
                        'Mula Sekarang!',
                      ),
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Get.theme.colorScheme.onInverseSurface),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Get.theme.colorScheme.secondary),
                        shadowColor: MaterialStateProperty.all<Color>(
                            Get.theme.colorScheme.secondary),
                        elevation: MaterialStateProperty.all<double>(10),
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
