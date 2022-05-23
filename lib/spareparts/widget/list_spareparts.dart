import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/home/controller/sparepart_controller.dart';
import 'package:admin_panel/spareparts/model/sparepart_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

class ListSpareparts extends StatelessWidget {
  final List<Spareparts> list;

  ListSpareparts({
    Key key,
    this.list,
  }) : super(key: key);

  final _sparepartsController = Get.find<SparepartController>();
  final _data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return list.length > 0
        ? RefreshIndicator(
            onRefresh: () async {
              await _sparepartsController.refreshDialog(false);
            },
            child: Scrollbar(
              child: AnimationLimiter(
                child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      var spareparts = list[i];
                      return AnimationConfiguration.staggeredList(
                        position: i,
                        duration: const Duration(milliseconds: 400),
                        child: SlideAnimation(
                          child: FadeInAnimation(
                            child: ListTile(
                                leading: Hero(
                                  tag: spareparts.id,
                                  child: CircleAvatar(
                                    backgroundColor: Get.theme.primaryColor,
                                    child: Text(
                                      spareparts.supplier == 'Lain...'
                                          ? '...'
                                          : '${spareparts.supplier}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                    '${spareparts.jenisSpareparts} ${spareparts.model} (${spareparts.kualiti})'),
                                subtitle: Text(spareparts.maklumatSpareparts),
                                trailing: Text('RM${spareparts.harga}'),
                                onTap: () {
                                  print(spareparts.partsID);
                                  _sparepartsController.isSearch.value = false;
                                  if (_data == null) {
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
                                    _sparepartsController.goToDetails(
                                        arguments, spareparts.id);
                                  } else {
                                    final data = {
                                      'model':
                                          '${spareparts.jenisSpareparts} ${spareparts.model} (${spareparts.kualiti})',
                                      'id': spareparts.id,
                                      'harga': spareparts.harga,
                                    };
                                    Get.back(result: data);
                                  }
                                }),
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
                Icon(
                  Icons.browser_not_supported,
                  size: 120,
                  color: Colors.grey,
                ),
                SizedBox(height: 10),
                Text(
                  'Maaf, tiada spareparts ditemui untuk model ini!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: 260,
                  height: 40,
                  child: TextButton.icon(
                    onPressed: () {
                      Haptic.feedbackClick();
                      Get.toNamed(MyRoutes.sparepartsAdd);
                    },
                    icon: Icon(Icons.add),
                    label: Text('Tambah Spareparts'),
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    await _sparepartsController.refreshDialog(true);
                  },
                  icon: Icon(Icons.refresh),
                  label: Text('Segar Semula'),
                ),
              ],
            ),
          );
  }
}
