import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/home/controller/sparepart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widget/sparepart_card.dart';

class SparepartPage extends StatelessWidget {
  final _sparepartController = Get.find<SparepartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spareparts'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _sparepartController.refreshDialog(false);
        },
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 20),
              SparepartsCard(false),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 25, 15, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Senarai Spareparts',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Haptic.feedbackClick();
                        return Get.toNamed(MyRoutes.spareparts);
                      },
                      child: Text(
                        'Lihat Semua',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: _sparepartController.getPartList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: LinearProgressIndicator(),
                    );
                  }
                  return GetBuilder<SparepartController>(
                    assignId: true,
                    builder: (logic) {
                      return ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _sparepartController.spareparts.length >= 5
                              ? 5
                              : _sparepartController.spareparts.length,
                          itemBuilder: (context, i) {
                            var spareparts = _sparepartController.spareparts[i];
                            return ListTile(
                              leading: Hero(
                                tag: spareparts['id'],
                                child: CircleAvatar(
                                  backgroundColor: Get.theme.primaryColor,
                                  child: Text(
                                    spareparts['Supplier'] == 'Lain...'
                                        ? '...'
                                        : spareparts['Supplier'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              title: Text(
                                  '${spareparts['Jenis Spareparts']} ${spareparts['Model']}'),
                              subtitle: Text(spareparts['Maklumat Spareparts']),
                              onTap: () {
                                Haptic.feedbackClick();
                                var arguments = {
                                  'Model': spareparts['Model'],
                                  'Kualiti': spareparts['Kualiti'],
                                  'Jenis Spareparts':
                                      spareparts['Jenis Spareparts'],
                                  'Tarikh': spareparts['Tarikh'],
                                  'Harga': spareparts['Harga'],
                                  'Supplier': spareparts['Supplier'],
                                  'Maklumat Spareparts':
                                      spareparts['Maklumat Spareparts'],
                                };

                                Get.toNamed(
                                  MyRoutes.sparepartsDetails,
                                  arguments: arguments,
                                  parameters: {
                                    'id': spareparts['id'],
                                  },
                                );
                              },
                            );
                          });
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
