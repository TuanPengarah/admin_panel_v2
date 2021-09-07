import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/home/controller/home_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

class MySidPage extends StatelessWidget {
  final _homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MyStatus ID',
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('MyrepairID')
            .orderBy('isPayment', descending: false)
            .where('isPayment', isNotEqualTo: true)
            .orderBy('timeStamp', descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            Future.delayed(Duration(seconds: 1), () {
              _homeController.totalMysid.value = snapshot.data.size;
              if (snapshot.data.docs.isEmpty) {
                FlutterAppBadger.removeBadge();
              } else {
                FlutterAppBadger.updateBadgeCount(snapshot.data.size);
              }
            });
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
                    'Nampak gayanya anda tidak mempunyai sebarang Pending Job!',
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
                    child: Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Haptic.feedbackClick();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                leading:
                                    Icon(Icons.history, color: Colors.grey),
                                trailing: Icon(Icons.done, color: Colors.grey),
                                width: MediaQuery.of(context).size.width - 110,
                                lineHeight: 3.2,
                                percent: document['Percent'],
                                progressColor: Get.theme.accentColor,
                              ),
                              Center(
                                child: Text(
                                  'PERATUS UNTUK SIAP:',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  ' ${document['Percent'] * 100.round()}%',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
