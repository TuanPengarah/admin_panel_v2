import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/home/controller/sparepart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListSpareparts extends StatelessWidget {
  final List list;

  ListSpareparts({
    Key key,
    this.list,
  }) : super(key: key);

  final _sparepartsController = Get.find<SparepartController>();

  @override
  Widget build(BuildContext context) {
    return list.length > 0
        ? RefreshIndicator(
            onRefresh: () async {
              await _sparepartsController.getSparepartsList();
            },
            child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, i) {
                  var spareparts = list[i];
                  return ListTile(
                      leading: Hero(
                        tag: spareparts['id'],
                        child: CircleAvatar(
                          child: Text(
                            spareparts['Supplier'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      title: Text(
                          '${spareparts['Jenis Spareparts']} ${spareparts['Model']} (${spareparts['Kualiti']})'),
                      subtitle: Text(spareparts['Maklumat Spareparts']),
                      trailing: Text('RM${spareparts['Harga']}'),
                      onTap: () {
                        // ShowDetailParts.details(
                        //   title:
                        //       '${spareparts['Jenis Spareparts']} ${spareparts['Model']} (${spareparts['Kualiti']})',
                        //   id: spareparts['id'],
                        //   tarikh: spareparts['Tarikh'],
                        //   harga: spareparts['Harga'],
                        //   supplier: spareparts['Supplier'],
                        //   jenisSparepart: spareparts['Jenis Spareparts'],
                        //   maklumatSparepart: spareparts['Maklumat Spareparts'],
                        //   kualiti: spareparts['Kualiti'],
                        // );
                        var arguments = {
                          'Model': spareparts['Model'],
                          'Kualiti': spareparts['Kualiti'],
                          'Jenis Spareparts': spareparts['Jenis Spareparts'],
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
                      });
                }),
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
                    },
                    icon: Icon(Icons.add),
                    label: Text('Tambah Spareparts'),
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    await _sparepartsController.refreshDialog();
                  },
                  icon: Icon(Icons.refresh),
                  label: Text('Segar Semula'),
                ),
              ],
            ),
          );
  }
}
