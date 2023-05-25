import 'package:flutter/services.dart' show HapticFeedback;

class Haptic {
  static void feedbackSuccess() async {
    HapticFeedback.selectionClick();
    await Future.delayed(const Duration(milliseconds: 200));
    HapticFeedback.lightImpact();
  }

  static void feedbackError() async {
    HapticFeedback.selectionClick();
    await Future.delayed(const Duration(milliseconds: 200));
    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 200));
    HapticFeedback.lightImpact();
  }

  static void feedbackClick() async {
    HapticFeedback.lightImpact();
  }
}
