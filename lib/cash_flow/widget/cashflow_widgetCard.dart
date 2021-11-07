import 'package:admin_panel/cash_flow/controller/cashflow_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CashFlowCard extends GetView<CashFlowController> {
  const CashFlowCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      height: 200,
      width: Get.width,
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.grey[900] : Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Get.isDarkMode ? Colors.black26 : Colors.grey[500],
            offset: Offset(4.0, 4.0),
            blurRadius: 15,
            spreadRadius: 1.0,
          ),
          BoxShadow(
            color: Get.isDarkMode ? Colors.black26 : Colors.white,
            offset: Offset(-4.0, -4.0),
            blurRadius: 15,
            spreadRadius: 1.0,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text(
              'J U M L A H',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 15),
            Obx(() {
              return Text(
                controller.total.value < 0
                    ? 'RM--'
                    : 'RM ${controller.total.value}',
                style: TextStyle(
                  fontSize: 30,
                  color: Get.isDarkMode ? Colors.white : Colors.grey.shade800,
                ),
              );
            }),
            SizedBox(height: 30),
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _budget(
                    title: 'Masuk',
                    price: controller.total.value < 0
                        ? '--'
                        : '${controller.masuk.value}',
                    icon: Icons.arrow_upward_outlined,
                    color: Colors.green,
                  ),
                  _budget(
                    title: 'Keluar',
                    price: controller.total.value < 0
                        ? '--'
                        : '${controller.keluar.value}',
                    icon: Icons.arrow_downward_outlined,
                    color: Colors.red,
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Container _budget({
    String title,
    String price,
    IconData icon,
    Color color,
  }) {
    return Container(
      child: Row(
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(
              icon,
              color: color,
            ),
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title',
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                'RM$price',
                style: TextStyle(
                  color: Get.isDarkMode ? Colors.white : Colors.grey.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
