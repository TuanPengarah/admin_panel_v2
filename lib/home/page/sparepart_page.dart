import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/home/controller/sparepart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SparepartPage extends StatelessWidget {
  final _sparepartController = Get.put(SparepartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        physics: BouncingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text('Spareparts'),
              pinned: true,
            ),
          ];
        },
        body: Column(
          children: [
            SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              width: Get.width,
              decoration: BoxDecoration(
                color: Get.theme.primaryColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jumlah Spareparts: ',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 18,
                        letterSpacing: 1.5,
                        wordSpacing: 2.8,
                      ),
                    ),
                    SizedBox(height: 5),
                    Obx(() {
                      return Text(
                        '${_sparepartController.totalSpareparts}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
                    SizedBox(height: 10),
                    Text(
                      'Harga Keseluruhan: ',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 18,
                        letterSpacing: 1.5,
                        wordSpacing: 2.8,
                      ),
                    ),
                    SizedBox(height: 5),
                    Obx(() {
                      return Text(
                        'RM ${_sparepartController.totalPartsPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
                    SizedBox(height: 22),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Haptic.feedbackClick();
                          Get.toNamed(MyRoutes.sparepartsAdd);
                        },
                        icon: Icon(Icons.add),
                        label: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Text('Tambah Spareparts'),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white24),
                          shadowColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                    child: CircularProgressIndicator(),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, i) {
                        var spareparts = _sparepartController.spareparts[i];
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
                        );
                      }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

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
