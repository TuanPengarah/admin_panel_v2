import 'package:admin_panel/POS/controller/payment_controller.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/home/widget/mysid_list_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class POSView extends StatelessWidget {
  final _controller = Get.find<PaymentController>();

  POSView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Payment'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('MyrepairID')
            .where('Percent', isEqualTo: 1)
            .where('isPayment', isEqualTo: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.money_off,
                          color: Colors.grey, size: 120),
                      const SizedBox(height: 10),
                      const Text(
                        'Maaf! tidak menjumpai sebarang pending payment',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        height: 45,
                        width: 250,
                        child: ElevatedButton(
                          onPressed: () => Get.toNamed(
                            MyRoutes.jobsheet,
                            arguments: [false, '', '', '', ''],
                          ),
                          child: const Text('Buat Jobsheet'),
                        ),
                      ),
                    ]),
              ),
            ));
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return MysidUI.mySidListCard(doc, context, () {
                var data = {
                  'model': doc['Model'],
                };
                _controller.mysid = doc['MID'];
                _controller.customerUID = doc['Database UID'];
                _controller.customerName = doc['Nama'];
                _controller.phoneNumber = doc['No Phone'];
                Get.toNamed(MyRoutes.paymentSetup, arguments: data);
              });
            }).toList(),
          );
        },
      ),
    );
  }
}
