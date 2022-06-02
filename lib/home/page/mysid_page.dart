import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/home/controller/home_controller.dart';
import 'package:admin_panel/home/widget/mysid_list_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:get/get.dart';

class MySidPage extends StatelessWidget {
  final _homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 150,
            leading: Icon(Icons.date_range_outlined),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'MyStatus ID',
                style: TextStyle(
                  color: Get.theme.colorScheme.inverseSurface,
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.history),
                onPressed: () {
                  Haptic.feedbackClick();
                  Get.toNamed(MyRoutes.mysidHisory);
                },
              ),
            ],
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            const SizedBox(height: 20),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('MyrepairID')
                  .orderBy('isPayment', descending: false)
                  .where('isPayment', isNotEqualTo: true)
                  .orderBy('timeStamp', descending: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  Future.delayed(Duration(seconds: 1), () {
                    _homeController.totalMysid.value = snapshot.data.size;
                    if (snapshot.data.docs.isEmpty) {
                      if (!GetPlatform.isWeb) {
                        FlutterAppBadger.removeBadge();
                      }
                    } else {
                      if (!GetPlatform.isWeb) {
                        FlutterAppBadger.updateBadgeCount(snapshot.data.size);
                      }
                    }
                  });
                }
                if (snapshot.data.docs.isEmpty) {
                  Future.delayed(Duration(seconds: 1), () {
                    _homeController.totalMysid.value = snapshot.data.size;
                  });
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
                return Column(
                  children: snapshot.data.docs.map(
                    (document) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 3),
                        child: Hero(
                          tag: document.id,
                          child: MysidUI.mySidListCard(document, context, () {
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
                );
              },
            ),
          ]))
        ],
      ),
    );
  }
}
