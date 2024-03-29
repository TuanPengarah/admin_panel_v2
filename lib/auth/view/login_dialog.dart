import 'package:admin_panel/auth/controller/firebase_auth_controller.dart';
import 'package:admin_panel/auth/controller/show_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ShowBottomSheet {
  static void showLoginSheet(
    BuildContext context,
    AuthController authController,
  ) async {
    final emailField = TextEditingController();
    final passwordField = TextEditingController();
    final btnController = RoundedLoadingButtonController();
    final visiblityController = Get.put(ShowPasswordController());

    Get.bottomSheet(
      GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: AutofillGroup(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Log Masuk Sekarang!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Sila log masuk ke akaun anda untuk teruskan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 50),
                    TextField(
                      controller: emailField,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Masukkan alamat email',
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => TextField(
                        controller: passwordField,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: visiblityController.showPassword.value,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (text) {
                          btnController.start();
                          TextInput.finishAutofillContext();
                        },
                        autofillHints: const [AutofillHints.password],
                        decoration: InputDecoration(
                          labelText: 'Kata Laluan',
                          hintText: 'Sila masukkan kata laluan yang sah',
                          prefixIcon: const Icon(Icons.password),
                          suffixIcon: IconButton(
                            icon: Icon(
                              visiblityController.showPassword.value == true
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              visiblityController.showPassword.toggle();
                              debugPrint(visiblityController.showPassword.value
                                  .toString());
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    RoundedLoadingButton(
                      color: Get.theme.colorScheme.secondary,
                      controller: btnController,
                      errorColor: Get.theme.colorScheme.error,
                      successColor: Colors.green,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        authController.performLogin(
                          emailField.text,
                          passwordField.text,
                          btnController,
                        );
                      },
                      child: Text(
                        'Log Masuk',
                        style: TextStyle(
                          color: Get.theme.colorScheme.background,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text.rich(
                      TextSpan(
                        text:
                            'Ingin membuat Akaun baru? Pastikan anda staff Af-Fix dan sila hubungi ',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(
                            text: 'Akid Fikri Azhar',
                            style: TextStyle(
                              color: Get.theme.colorScheme.primary,
                            ),
                          ),
                          const TextSpan(text: ' untuk membuat akaun baru!')
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
      ),
      isDismissible: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
    );
  }
}
