import 'package:admin_panel/POS/controller/payment_controller.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BillsView extends StatelessWidget {
  final _paymentController = Get.put(PaymentController());

  BillsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Buat Invois'),
          actions: [
            IconButton(
              onPressed: () => Get.toNamed(MyRoutes.posview),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: GetBuilder<PaymentController>(builder: (logic) {
          return _paymentController.bills.isNotEmpty
              ? Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _paymentController.bills.length,
                        itemBuilder: (context, i) {
                          var receipt = _paymentController.bills[i];
                          return ListTile(
                            leading: Icon(receipt['isPending'] == true
                                ? Icons.pending_actions
                                : Icons.add),
                            title: Text(receipt['title']),
                            subtitle: Text(receipt['waranti']),
                            trailing: Text('RM ${receipt['harga'].toString()}'),
                            onTap: () {},
                          );
                        },
                      ),
                    ),
                    Container(
                      color: Get.isDarkMode
                          ? Colors.grey.shade900
                          : Colors.grey.shade200,
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: Get.width - 140,
                            child: ElevatedButton(
                              onPressed: () => _paymentController.choosePrint(),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                              ),
                              child: const Text('Hasilkan Resit'),
                            ),
                          ),
                          Obx(() {
                            return Text(
                              'Jumlah:\n RM ${_paymentController.totalBillsPrice.value}',
                              textAlign: TextAlign.center,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt,
                          size: 120,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 18),
                        Text(
                          'Sila tekan + untuk membuat invois',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                );
        }));
  }
}
