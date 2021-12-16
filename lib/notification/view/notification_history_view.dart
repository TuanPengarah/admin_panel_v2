import 'package:admin_panel/API/sqlite.dart';
import 'package:admin_panel/notification/controller/notification_controller.dart';
import 'package:admin_panel/notification/model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../config/haptic_feedback.dart';

class NotificationHistoryView extends GetView<NotificationController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sejarah Notifikasi'),
          actions: [
            IconButton(
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    title: Text('Buang Semua Notifikasi?'),
                    content: Text(
                        'Adakah anda pasti untuk membuang semua notifikasi?'),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          List<NotificationModel> history = await DatabaseHelper
                              .instance
                              .getNotificationHistory();
                          await controller.deleteAllNotification(history);
                          Get.back();
                        },
                        child: Text(
                          'Pasti',
                          style: TextStyle(
                            color: Colors.amber[900],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Haptic.feedbackClick();
                          Get.back();
                        },
                        child: Text(
                          'Batal',
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
        body: GetBuilder<NotificationController>(
          init: NotificationController(),
          builder: (_) {
            return Center(
              child: FutureBuilder(
                  future: DatabaseHelper.instance.getNotificationHistory(),
                  builder: (context,
                      AsyncSnapshot<List<NotificationModel>> snapshot) {
                    if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Spacer(),
                            Icon(
                              Icons.error_outline,
                              size: 130,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Kesalahan telah berlaku!',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: () {
                                Get.dialog(
                                  AlertDialog(
                                    content: SelectableText(
                                      snapshot.error.toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Get.back(),
                                        child: Text('Tutup'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Text('Klik sini untuk lebih lanjut'),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: const Text('Memuatkan data...'),
                      );
                    } else if (snapshot.data.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.notifications_off_outlined,
                            size: 150,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10),
                          const Text(
                            'Tiada sejarah notifikasi ditemui',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () =>
                          DatabaseHelper.instance.getNotificationHistory(),
                      child: AnimationLimiter(
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, i) {
                              var history = snapshot.data[i];
                              DateTime tarikhParse =
                                  DateTime.parse(history.tarikh);
                              String tarikh = DateFormat('dd-MM-yyyy | hh:mm a')
                                  .format(tarikhParse)
                                  .toString();
                              return AnimationConfiguration.staggeredList(
                                position: i,
                                duration: const Duration(milliseconds: 400),
                                child: SlideAnimation(
                                  child: FadeInAnimation(
                                    child: ListTile(
                                      leading: Icon(
                                          history.title.contains('Mesej dari')
                                              ? Icons.message
                                              : Icons.notifications),
                                      title: Text('${history.title}'),
                                      subtitle:
                                          Text('${history.body}\n $tarikh'),
                                      isThreeLine: true,
                                      onTap: () {
                                        print(history.id);
                                      },
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    );
                  }),
            );
          },
        ));
  }
}
