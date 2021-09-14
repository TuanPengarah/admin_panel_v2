import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:admin_panel/home/controller/sparepart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListSpareparts extends StatefulWidget {
  final List list;

  const ListSpareparts({
    Key key,
    this.list,
  }) : super(key: key);

  @override
  _ListSparepartsState createState() => _ListSparepartsState();
}

class _ListSparepartsState extends State<ListSpareparts> {
  final _sparepartsController = Get.find<SparepartController>();
  @override
  Widget build(BuildContext context) {
    return widget.list.length > 0
        ? RefreshIndicator(
            onRefresh: () async {
              await _sparepartsController.getSparepartsList();
              setState(() {});
            },
            child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: widget.list.length,
                itemBuilder: (context, i) {
                  var spareparts = widget.list[i];
                  return ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          spareparts['Supplier'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                          '${spareparts['Jenis Spareparts']} ${spareparts['Model']}'),
                      subtitle: Text(spareparts['Maklumat Spareparts']),
                      onTap: () {
                        print(spareparts['id']);
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
                    Haptic.feedbackClick();
                    await _sparepartsController.getSparepartsList();
                    ShowSnackbar.success(
                        'Segar Semula', 'Segar semula selesai', false);
                    Haptic.feedbackSuccess();
                    setState(() {});
                  },
                  icon: Icon(Icons.refresh),
                  label: Text('Segar Semula'),
                ),
              ],
            ),
          );
  }
}
