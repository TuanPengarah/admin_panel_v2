import 'package:admin_panel/API/sms_api.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/home/page/customer_page.dart';
import 'package:admin_panel/sms/model/sms_status_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SMSController extends GetxController {
  final recipientText = TextEditingController();
  final messageText = TextEditingController();

  void getCustomer() {
    Haptic.feedbackClick();
    Get.to(() => CustomerPage(true));
  }

  void getBack() {
    Haptic.feedbackError();
    Get.back();
  }

  Future<String> sendSMS() async {
    String status = '';
    await SMSApi().sendSMS(recipientText.text, messageText.text).then((value) {
      SMSStatusModel result = SMSStatusModel.get(value.body);
      debugPrint('${value.statusCode} ${value.statusText}');
      debugPrint('${result.status} ${result.reason}');
      status = result.reason;
      return '$status';
    });
    return status;
  }

  bool isReady() {
    if (recipientText.text.isEmpty && messageText.text.isEmpty) {
      return false;
    }
    return true;
  }
}
