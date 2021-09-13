import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RepairLogView extends StatelessWidget {
  final _params = Get.parameters;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Repair Log'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('MyrepairID')
              .doc(_params['id'])
              .collection('repair log')
              .orderBy('timeStamp', descending: false)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data.docs.isEmpty) {
              return SizedBox(
                width: Get.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.browser_not_supported,
                      size: 120,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Maaf! Repair Log tidak dapat ditemui',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView(
              physics: BouncingScrollPhysics(),
              children: snapshot.data.docs.map((doc) {
                DateTime dt = (doc['timeStamp'] as Timestamp).toDate();
                String date =
                    DateFormat('dd-MM-yyyy | hh:mm a').format(dt).toString();
                bool isError = doc['isError'];
                return ListTile(
                  leading:
                      Icon(isError == true ? Icons.report_problem : Icons.done),
                  title: Text(doc['Repair Log']),
                  subtitle: Text(date),
                );
              }).toList(),
            );
          }),
    );
  }
}
