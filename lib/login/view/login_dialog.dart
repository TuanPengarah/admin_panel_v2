import 'package:admin_panel/API/firebaseAuth_controller.dart';
import 'package:admin_panel/login/controller/show_password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class ShowBottomSheet {
  static void showLoginSheet(
    BuildContext context,
    AuthController loginController,
    ShowPasswordController visiblityController,
  ) async {
    final emailField = TextEditingController();
    final passwordField = TextEditingController();
    final btnController = RoundedLoadingButtonController();
    await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
        isDismissable: false,
        color: Theme.of(context).scaffoldBackgroundColor,
        duration: Duration(milliseconds: 400),
        snapSpec: SnapSpec(snappings: [1, 1]),
        elevation: 8,
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SafeArea(
              child: Material(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Text(
                          'Log Masuk Sekarang!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Sila log masuk ke akaun anda untuk teruskan',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 50),
                        TextField(
                          controller: emailField,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Masukkan alamat email',
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                        SizedBox(height: 20),
                        Obx(
                          () => TextField(
                            controller: passwordField,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: visiblityController.showPassword.value,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (text) {
                              btnController.start();
                            },
                            decoration: InputDecoration(
                              labelText: 'Kata Laluan',
                              hintText: 'Sila masukkan kata laluan yang sah',
                              prefixIcon: Icon(Icons.password),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  visiblityController.showPassword.value == true
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  visiblityController.showPassword.toggle();
                                  print(visiblityController.showPassword.value);
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 50),
                        RoundedLoadingButton(
                          controller: btnController,
                          child: Text(
                            'Log Masuk',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          errorColor: Colors.amber[900],
                          successColor: Colors.green,
                          onPressed: () {
                            loginController.performLogin(
                              emailField.text,
                              passwordField.text,
                              btnController,
                            );
                          },
                        ),
                        SizedBox(height: 30),
                        Text.rich(
                          TextSpan(
                            text:
                                'Ingin membuat Akaun baru? Pastikan anda staff Af-Fix dan sila hubungi ',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                            children: [
                              TextSpan(
                                text: 'Akid Fikri Azhar',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              TextSpan(text: ' untuk membuat akaun baru!')
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
