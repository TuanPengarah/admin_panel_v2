import 'package:admin_panel/cash_flow/controller/cashflow_controller.dart';
import 'package:admin_panel/cash_flow/widget/cashflow_widgetAdd.dart';
import 'package:admin_panel/cash_flow/widget/cashflow_widgetCard.dart';
import 'package:admin_panel/cash_flow/widget/cashflow_widgetList.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CashFlowView extends GetView<CashFlowController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? Colors.grey[800] : Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Get.isDarkMode ? Colors.grey[800] : Colors.grey[300],
        elevation: 0,
        foregroundColor: Get.isDarkMode ? Colors.white : Colors.black,
        title: Text('Cash Flow'),
        actions: [
          IconButton(
            onPressed: () async {
              Haptic.feedbackClick();
              Get.dialog(
                AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  ),
                ),
              );
              await controller.getCashFlow();
              Get.back();
              Haptic.feedbackSuccess();
            },
            icon: Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),
      body: GetBuilder<CashFlowController>(
        assignId: true,
        builder: (logic) {
          return Column(
            children: [
              CashFlowCard(false),
              ListCashFlow(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CashFlowAdd(
                    isAdd: true,
                    isEdit: false,
                  ),
                  CashFlowAdd(
                    isAdd: false,
                    isEdit: false,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
