import 'package:admin_panel/cash_flow/controller/cashflow_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CashFlowCard extends GetView<CashFlowController> {
  final bool isAllRecord;

  const CashFlowCard(this.isAllRecord, {super.key});

  @override
  Widget build(BuildContext context) {
    return isAllRecord == false
        ? Container(
            margin: const EdgeInsets.all(15),
            // height: 200,
            width: Get.width,
            decoration: BoxDecoration(
              color: Get.isDarkMode ? Colors.grey[900] : Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Get.isDarkMode
                      ? const Color.fromARGB(66, 15, 13, 13)
                      : Colors.grey.shade500,
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
            child: _content(),
          )
        : Card(
            // elevation: 0,
            margin: const EdgeInsets.symmetric(horizontal: 18),
            child: _content(),
          );
  }

  Padding _content() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          const Text(
            'J U M L A H',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 15),
          Obx(() {
            return Text(
              // controller.total.value < 0
              //     ? 'RM--'
              //     :
              'RM ${controller.total.value.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 30,
                color: Get.isDarkMode ? Colors.white : Colors.grey.shade800,
              ),
            );
          }),
          const SizedBox(height: 30),
          Obx(() {
            return Wrap(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              spacing: 10,
              runSpacing: 10,
              children: [
                _budget(
                  title: 'Masuk',
                  price: controller.masuk.value.toStringAsFixed(2),
                  icon: Icons.arrow_upward_outlined,
                  color: Colors.green,
                ),
                _budget(
                  title: 'Keluar',
                  price: controller.keluar.value.toStringAsFixed(2),
                  icon: Icons.arrow_downward_outlined,
                  color: Colors.red,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Row _budget({
    required String title,
    required String price,
    required IconData icon,
    required Color color,
  }) {
    return Row(
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
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.grey),
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
    );
  }
}
