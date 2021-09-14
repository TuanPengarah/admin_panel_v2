import 'package:admin_panel/home/controller/sparepart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SparepartPage extends StatelessWidget {
  final _sparepartController = Get.put(SparepartController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Spareparts',
        ),
        actions: [
          IconButton(
            onPressed: () {
              ///sorting to alphabet///
              // print(_sparepartController.spareparts
              //   ..sort((a, b) => a['Model'].compareTo(b['Model'])));
              ///Sorting to model name//////
              // print(_sparepartController.spareparts
              //     .where((e) => e['Model']
              //         .toString()
              //         .toLowerCase()
              //         .contains('Oppo'.toLowerCase()))
              //     .toList());
            },
            icon: Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: _sparepartController.spareparts.length,
          itemBuilder: (context, i) {
            var spareparts = _sparepartController.spareparts[i];
            var key = _sparepartController.keys[i];
            return ListTile(
              title: Text(spareparts['Model']),
              subtitle: Text(spareparts['Jenis Spareparts']),
              onTap: () {
                print(key);
              },
            );
          }),
    );
  }
}
