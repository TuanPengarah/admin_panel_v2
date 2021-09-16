import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddSparepartsController extends GetxController {
  final modelParts = TextEditingController();
  var selectedSupplier = 'MG'.obs;
  var currentSteps = 0.obs;
}
