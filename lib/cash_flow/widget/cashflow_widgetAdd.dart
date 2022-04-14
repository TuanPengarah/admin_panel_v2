import 'package:admin_panel/cash_flow/controller/cashflow_controller.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cashflow_bottomsheet.dart';

class CashFlowAdd extends GetView<CashFlowController> {
  final bool isAdd;
  final bool isEdit;
  CashFlowAdd({@required this.isAdd, @required this.isEdit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {
          controller.resetAdd();
          isAdd == true
              ? bottomSheetCashFlow(isEdit, '')
              : Get.toNamed(MyRoutes.cashFlowViewAll);
        },
        borderRadius: BorderRadius.circular(100),
        child: Ink(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            color: Get.isDarkMode ? Colors.grey[900] : Colors.grey,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Icon(
            isAdd == true ? Icons.add : Icons.open_in_new,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
