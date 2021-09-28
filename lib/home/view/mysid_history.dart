import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/home/widget/mysid_list_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MysidHistoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sejarah MyStatus ID',
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('MyrepairID')
            .orderBy('timeStamp', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data.docs.isEmpty) {
            return Container(
              width: Get.width,
              padding: EdgeInsets.all(18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.date_range,
                    size: 100,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Nampak gayanya anda tidak mempunyai sebarang MyStatus ID!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            );
          }
          return Scrollbar(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: snapshot.data.docs.map(
                (document) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 3),
                    child: Hero(
                      tag: document.id,
                      child: MysidUI.mySidListCard(document, context, (){
                        Haptic.feedbackClick();
                        var params = <String, String>{
                          'id': document.id,
                        };

                        var args = {
                          'Nama': document['Nama'],
                          'Model': document['Model'],
                          'Kerosakkan': document['Kerosakkan'],
                          'Password': document['Password'],
                          'Remarks': document['Remarks'],
                          'Percent': document['Percent'],
                          'No Phone': document['No Phone'],
                        };
                        Get.toNamed(
                          MyRoutes.mysidUpdate,
                          parameters: params,
                          arguments: args,
                        );
                      }),
                    ),
                  );
                },
              ).toList(),
            ),
          );
        },
      ),
    );
  }
}
