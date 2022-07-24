import 'dart:math';

import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/price_list/controller/pricelist_controller.dart';
import 'package:admin_panel/price_list/model/pricelist_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class TabPriceList extends StatelessWidget {
  final List<PriceListModel> list;
  TabPriceList({@required this.list});

  final _controller = Get.find<PriceListController>();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _controller.getList.timeout(Duration(seconds: 10)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: 20,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Get.isDarkMode
                            ? Colors.grey.shade900
                            : Colors.grey[300],
                        highlightColor: Get.isDarkMode
                            ? Colors.grey.shade800
                            : Colors.grey[200],
                        child: Container(
                          height: 13,
                          width: Random().nextInt(250).toDouble() + 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                );
              });
        } else if (_controller.internet.value == true ||
            _controller.offlineMode.value == true) {
          return list.length > 0
              ? RefreshIndicator(
                  onRefresh: () async => await _controller.getPriceList(),
                  child: AnimationLimiter(
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) {
                        var pricelist = list[index];
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 400),
                          child: SlideAnimation(
                            child: FadeInAnimation(
                              child: ListTile(
                                title: Text(
                                    '${pricelist.parts} ${pricelist.model}'),
                                subtitle: Text('RM ${pricelist.harga}'),
                                onTap: () {
                                  Haptic.feedbackSuccess();
                                  _controller.priceListInfo(pricelist);
                                },
                              ),
                            ),
                          ),
                        );
                      },
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
                        'Maaf, tiada senarai harga ditemui untuk model ini!',
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
                            _controller.addListDialog(isEdit: false);
                          },
                          icon: Icon(Icons.add),
                          label: Text('Tambah Senarai Harga'),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          Get.dialog(
                            AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(),
                                ],
                              ),
                            ),
                          );
                          await _controller.getPriceList();
                          Get.back();
                        },
                        icon: Icon(Icons.refresh),
                        label: Text('Segar Semula'),
                      ),
                    ],
                  ),
                );
        } else if (_controller.internet.value == false) {
          return GetBuilder<PriceListController>(
            builder: (_) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const Icon(
                      Icons.warning,
                      size: 120,
                      // color: Colors.grey,
                    ),
                    const Text(
                      'Gagal untuk memuat turun senarai harga!',
                      textAlign: TextAlign.center,
                      // style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: _controller.activateOffline,
                      child: Text('Aktifkan Mod Luar Talian'),
                    ),
                    const Spacer(),
                    Text(
                      '${_controller.errorText.value}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
