import 'package:admin_panel/cash_flow/controller/cashflow_controller.dart';
import 'package:admin_panel/cash_flow/widget/cashflow_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CashflowViewAll extends GetView<CashFlowController> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Hero(
        tag: 'cf',
        child: Scaffold(
          appBar: AppBar(title: Text('Senarai Cash Flow')),
          body: FutureBuilder(
              future: controller.initCashFlow,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return GetBuilder<CashFlowController>(builder: (context) {
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: controller.cashFlow.length,
                    itemBuilder: (context, i) {
                      var cash = controller.cashFlow[i];
                      DateTime dt = cash.timeStamp.toDate();
                      String date = DateFormat('dd-MM-yyyy | hh:mm a')
                          .format(dt)
                          .toString();
                      return ListTile(
                        title: Text(cash.remark),
                        subtitle: Text(date),
                        trailing: cash.isModal == true
                            ? Text(
                                '-RM${cash.jumlah}',
                                style: TextStyle(color: Colors.red),
                              )
                            : Text(
                                '+RM${cash.jumlah}',
                                style: TextStyle(color: Colors.green),
                              ),
                        onLongPress: () {
                          controller.hargaText.text = cash.jumlah.toString();
                          controller.remarksText.text = cash.remark.toString();
                          controller.isModal.value = cash.isModal;
                          controller.isJualPhone.value = cash.isJualPhone;
                          controller.isSparepart.value = cash.isSpareparts;
                          bottomSheetCashFlow(true, cash.id);
                        },
                      );
                    },
                  );
                });
              }),
        ),
      ),
    );
  }
}
