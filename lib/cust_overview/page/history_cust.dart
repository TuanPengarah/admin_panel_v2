import 'package:admin_panel/config/status_icon.dart';
import 'package:admin_panel/cust_overview/controller/history_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

class RepairHistoryPage extends StatelessWidget {
  const RepairHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final historyController = Get.put(RepairHistoryController());
    return NestedScrollView(
      physics: const BouncingScrollPhysics(),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: 180.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Sejarah Baiki',
                style: TextStyle(
                  color: Get.theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ];
      },
      body: FutureBuilder(
        future: historyController.getFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (historyController.items.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(12.0),
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
              const SizedBox(height: 20),
              Obx(
                () => historyController.totalPrice.value == '0.0'
                    ? const Text(
                        'Pelanggan ini tidak pernah mengeluarkan modal',
                        style: TextStyle(color: Colors.grey),
                      )
                    : Text.rich(
                        TextSpan(
                          text: 'Jumlah yang telah dibelanjakan:',
                          style: const TextStyle(color: Colors.grey),
                          children: [
                            TextSpan(
                              text: ' RM${historyController.totalPrice.value}',
                              style: TextStyle(
                                color: Get.theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              Expanded(
                child: AnimationLimiter(
                  child: ListView.builder(
                    itemCount: historyController.items.length,
                    itemBuilder: (context, int i) {
                      var doc = historyController.items[i];
                      return AnimationConfiguration.staggeredList(
                        position: i,
                        duration: const Duration(milliseconds: 400),
                        child: SlideAnimation(
                          verticalOffset: 80.0,
                          child: FadeInAnimation(
                            child: historyCard(doc, historyController),
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
    final data = Get.arguments;
    return Card(
      child: Ink(
        child: InkWell(
          onTap: () {
            var payload = <String, dynamic>{
              'nama': data['Nama'],
              'noTel': data['No Phone'],
              'model': doc['Model'],
              'kerosakkan': doc['Kerosakkan'].toString(),
              'price': doc['Harga'].toString(),
              'remarks': doc['Remarks'],
              'mysid': doc['MID'],
              'email': data['Email'],
              'timeStamp': doc['timeStamp'],
              'technician': doc['Technician'],
              'status': doc['Status'],
              'tarikh': doc['Tarikh'],
              'waranti': doc['Tarikh Waranti'],
              'password': doc['Password'],
            };
            controller.showShareJobsheet(payload);
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
                        style: const TextStyle(fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      doc['MID'],
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  doc['Kerosakkan'],
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 5),
                Text(
                  doc['Remarks'],
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'RM${doc['Harga']}',
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.grey,
                      ),
                    ),
                    StatusIcon(doc['Status']),
                  ],
                ),
                const SizedBox(height: 5),
                doc['Status'] == 'Selesai'
                    ? Text(
                        'Waranti bermula dari ${doc['Tarikh']} hingga ${doc['Tarikh Waranti']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      )
                    : Container(),
                Text(
                  'Di uruskan oleh: ${doc['Technician']} pada tarikh ${doc['Tarikh']}',
                  style: const TextStyle(
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
