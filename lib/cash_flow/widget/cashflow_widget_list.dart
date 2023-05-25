import 'package:admin_panel/cash_flow/controller/cashflow_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ListCashFlow extends GetView<CashFlowController> {
  const ListCashFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Hero(
        tag: 'cf',
        child: Container(
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Get.isDarkMode ? Colors.grey[900] : Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Get.isDarkMode ? Colors.black26 : Colors.grey.shade500,
                offset: const Offset(4.0, 4.0),
                blurRadius: 15,
                spreadRadius: 1.0,
              ),
              BoxShadow(
                color: Get.isDarkMode ? Colors.black26 : Colors.white,
                offset: const Offset(-4.0, -4.0),
                blurRadius: 15,
                spreadRadius: 1.0,
              )
            ],
          ),
          child: FutureBuilder(
              future: controller.initCashFlow,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Material(
                  color: Colors.transparent,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.cashFlow.length,
                    itemBuilder: (context, i) {
                      var cash = controller.cashFlow[i];
                      DateTime dt = cash.timeStamp.toDate();
                      String date = DateFormat('dd-MM-yyyy | hh:mm a')
                          .format(dt)
                          .toString();
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: Get.isDarkMode
                              ? Colors.black26
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(cash.remark),
                          subtitle: Text(date),
                          trailing: cash.isModal == true
                              ? Text(
                                  '-RM${cash.jumlah}',
                                  style: const TextStyle(color: Colors.red),
                                )
                              : Text(
                                  '+RM${cash.jumlah}',
                                  style: const TextStyle(color: Colors.green),
                                ),
                        ),
                      );
                    },
                  ),
                );
              }),
        ),
      ),
    );
  }
}
