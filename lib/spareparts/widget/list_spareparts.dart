import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/home/controller/sparepart_controller.dart';
import 'package:admin_panel/spareparts/model/sparepart_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

class ListSpareparts extends StatelessWidget {
  final List<Spareparts>? list;

  ListSpareparts({
    super.key,
    this.list,
  });

  final _sparepartsController = Get.find<SparepartController>();
  final _data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return list!.isNotEmpty
        ? RefreshIndicator(
            onRefresh: () async {
              await _sparepartsController.refreshDialog(false);
            },
            child: Scrollbar(
              child: AnimationLimiter(
                child: ListView.builder(
                    itemCount: list!.length,
                    itemBuilder: (context, i) {
                      var spareparts = list![i];
                      return AnimationConfiguration.staggeredList(
                        position: i,
                        duration: const Duration(milliseconds: 400),
                        child: SlideAnimation(
                          child: FadeInAnimation(
                            child: listSpareparts(spareparts),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.browser_not_supported,
                  size: 120,
                  color: Colors.grey,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Maaf, tiada spareparts ditemui untuk model ini!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 260,
                  height: 40,
                  child: TextButton.icon(
                    onPressed: () {
                      Haptic.feedbackClick();
                      Get.toNamed(MyRoutes.sparepartsAdd);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Spareparts'),
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    await _sparepartsController.refreshDialog(true);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Segar Semula'),
                ),
              ],
            ),
          );
  }

  ListTile listSpareparts(Spareparts spareparts) {
    return ListTile(
        leading: Hero(
          tag: spareparts.id.toString(),
          child: CircleAvatar(
            backgroundColor: Get.theme.colorScheme.surfaceVariant,
            child: Text(
              spareparts.supplier == 'Lain...' ? '...' : spareparts.supplier,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Get.theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        title: Text(
            '${spareparts.jenisSpareparts} ${spareparts.model} (${spareparts.kualiti})'),
        subtitle: Text(spareparts.maklumatSpareparts),
        trailing: Text('RM${spareparts.harga}'),
        onTap: () {
          debugPrint(spareparts.partsID);
          _sparepartsController.isSearch.value = false;
          if (_data == null) {
            var arguments = {
              'Model': spareparts.model,
              'Kualiti': spareparts.kualiti,
              'Jenis Spareparts': spareparts.jenisSpareparts,
              'Tarikh': spareparts.tarikh,
              'Harga': spareparts.harga,
              'Supplier': spareparts.supplier,
              'Maklumat Spareparts': spareparts.maklumatSpareparts,
            };
            _sparepartsController.goToDetails(
                arguments, spareparts.id.toString());
          } else {
            final data = {
              'model':
                  '${spareparts.jenisSpareparts} ${spareparts.model} (${spareparts.kualiti})',
              'id': spareparts.id,
              'harga': spareparts.harga,
            };
            Get.back(result: data);
          }
        });
  }
}
