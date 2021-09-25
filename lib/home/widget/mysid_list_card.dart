import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../config/haptic_feedback.dart';
import '../../config/routes.dart';

class MysidUI{
 static Card mySidListCard(
      QueryDocumentSnapshot<Object> document, BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
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
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      document['Model'],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        document['Kerosakkan'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        document.id.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  document['Nama'],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  document['No Phone'],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              LinearPercentIndicator(
                leading: Icon(Icons.history, color: Colors.grey),
                trailing: Icon(Icons.done, color: Colors.grey),
                width: MediaQuery.of(context).size.width - 110,
                lineHeight: 3.2,
                percent: document['Percent'],
                progressColor: Get.theme.colorScheme.secondary,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'RM ${document['Harga'].toString()}',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      document['Tarikh'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}