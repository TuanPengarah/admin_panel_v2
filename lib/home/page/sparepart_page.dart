import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/home/controller/sparepart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widget/sparepart_card.dart';

class SparepartPage extends StatelessWidget {
  final _sparepartController = Get.find<SparepartController>();

  SparepartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Spareparts'),

      body: RefreshIndicator(
        onRefresh: () async {
          await _sparepartController.refreshDialog(false);
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 150,
              leading: const Icon(Icons.category_outlined),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Spareparts',
                  style: TextStyle(
                    color: Get.theme.colorScheme.inverseSurface,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    await _sparepartController.refreshDialog(false);
                  },
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      SparepartsCard(false),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 25, 15, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Senarai Spareparts',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Haptic.feedbackClick();
                                Get.toNamed(MyRoutes.spareparts);
                              },
                              child: const Text(
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
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: LinearProgressIndicator(),
                            );
                          }
                          return GetBuilder<SparepartController>(
                            assignId: true,
                            builder: (logic) {
                              return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _sparepartController
                                              .spareparts.length >=
                                          5
                                      ? 5
                                      : _sparepartController.spareparts.length,
                                  itemBuilder: (context, i) {
                                    var spareparts =
                                        _sparepartController.spareparts[i];
                                    return ListTile(
                                      leading: Hero(
                                        tag: spareparts.id.toString(),
                                        child: CircleAvatar(
                                          backgroundColor: Get
                                              .theme.colorScheme.surfaceVariant,
                                          child: Text(
                                            spareparts.supplier == 'Lain...'
                                                ? '...'
                                                : spareparts.supplier,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Get.theme.colorScheme
                                                    .onSurfaceVariant),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                          '${spareparts.jenisSpareparts} ${spareparts.model}'),
                                      subtitle:
                                          Text(spareparts.maklumatSpareparts),
                                      onTap: () {
                                        Haptic.feedbackClick();
                                        var arguments = {
                                          'Model': spareparts.model,
                                          'Kualiti': spareparts.kualiti,
                                          'Jenis Spareparts':
                                              spareparts.jenisSpareparts,
                                          'Tarikh': spareparts.tarikh,
                                          'Harga': spareparts.harga,
                                          'Supplier': spareparts.supplier,
                                          'Maklumat Spareparts':
                                              spareparts.maklumatSpareparts,
                                        };

                                        Get.toNamed(
                                          MyRoutes.sparepartsDetails,
                                          arguments: arguments,
                                          parameters: {
                                            'id': spareparts.id.toString(),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
