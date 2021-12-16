import 'package:admin_panel/config/status_icon.dart';
import 'package:admin_panel/cust_overview/controller/history_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

class RepairHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _historyController = Get.put(RepairHistoryController());
    return NestedScrollView(
      physics: BouncingScrollPhysics(),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: 180.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Sejarah Baiki'),
            ),
          ),
        ];
      },
      body: FutureBuilder(
        future: _historyController.getFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (_historyController.items.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.browser_not_supported,
                    color: Colors.grey,
                    size: 120,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Pelanggan ini tidak pernah membaiki sebarang peranti',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              SizedBox(height: 20),
              Obx(
                () => _historyController.totalPrice.value == '0.0'
                    ? Text(
                        'Pelanggan ini tidak pernah mengeluarkan modal',
                        style: TextStyle(color: Colors.grey),
                      )
                    : Text.rich(
                        TextSpan(
                          text: 'Jumlah yang telah dibelanjakan:',
                          style: TextStyle(color: Colors.grey),
                          children: [
                            TextSpan(
                              text: ' RM${_historyController.totalPrice.value}',
                              style: TextStyle(
                                color: Get.theme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              Expanded(
                child: AnimationLimiter(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: _historyController.items.length,
                    itemBuilder: (context, int i) {
                      var doc = _historyController.items[i];
                      return AnimationConfiguration.staggeredList(
                        position: i,
                        duration: const Duration(milliseconds: 400),
                        child: SlideAnimation(
                          verticalOffset: 80.0,
                          child: FadeInAnimation(
                            child: historyCard(doc, _historyController),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Card historyCard(dynamic doc, RepairHistoryController controller) {
    final _data = Get.arguments;
    return Card(
      child: Ink(
        child: InkWell(
          onTap: () {
            if (!GetPlatform.isWeb) {
              var payload = <String, dynamic>{
                'nama': _data[1],
                'noTel': _data[3],
                'model': doc['Model'],
                'kerosakkan': doc['Kerosakkan'].toString(),
                'price': doc['Harga'].toString(),
                'remarks': doc['Remarks'],
                'mysid': doc['MID'],
                'email': _data[4],
                'timeStamp': doc['timeStamp'],
                'technician': doc['Technician'],
                'status': doc['Status'],
                'waranti': doc['Tarikh Waranti'],
              };
              controller.showShareJobsheet(payload);
            }
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        doc['Model'],
                        style: TextStyle(fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      doc['MID'],
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  doc['Kerosakkan'],
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 5),
                Text(
                  doc['Remarks'],
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'RM${doc['Harga']}',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.grey,
                      ),
                    ),
                    StatusIcon(doc['Status']),
                  ],
                ),
                SizedBox(height: 5),
                doc['Status'] == 'Selesai'
                    ? Text(
                        'Waranti bermula dari ${doc['Tarikh']} hingga ${doc['Tarikh Waranti']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      )
                    : Container(),
                Text(
                  'Di uruskan oleh: ${doc['Technician']} pada tarikh ${doc['Tarikh']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
