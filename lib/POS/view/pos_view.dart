import 'package:admin_panel/POS/controller/payment_controller.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/home/widget/mysid_list_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class POSView extends StatelessWidget {
  final _controller = Get.find<PaymentController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Payment'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('MyrepairID')
            .where('Percent', isEqualTo: 1)
            .where('isPayment', isEqualTo: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data.docs.isEmpty) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.money_off, color: Colors.grey, size: 120),
                    SizedBox(height: 10),
                    Text(
                      'Maaf! tidak menjumpai sebarang pending payment',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ]),
            ));
          }
          return ListView(
            children: snapshot.data.docs.map((doc) {
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
