import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/home/controller/mysid_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RepairLogView extends StatelessWidget {
  final _params = Get.parameters;
  final _controller = Get.find<MysidController>();

  RepairLogView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repair Log'),
        actions: [
          IconButton(
            onPressed: () => _controller.urlMysid(_params['id'].toString()),
            icon: const Icon(Icons.open_in_browser),
          ),
          IconButton(
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  title: const Text(
                    'Tanda Sebagai Tidak Boleh Dibaiki?',
                    textAlign: TextAlign.center,
                  ),
                  content: const Text(
                    'Jika anda tanda sebagai tidak boleh dibaiki, Anda tidak boleh untuk membuka resit dan akan di padam pada halaman MyStatus ID',
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Haptic.feedbackError();
                        Get.back();
                      },
                      child: Text(
                        'Batal',
                        style: TextStyle(
                          color: Colors.amber[900],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async => await _controller
                          .setAsCannotRepair(_params['id'].toString()),
                      child: const Text('Tanda'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.error_outline),
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('MyrepairID')
              .doc(_params['id'])
              .collection('repair log')
              .orderBy('timeStamp', descending: false)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return SizedBox(
                width: Get.width,
                child: const Column(
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
                      'Maaf! Repair Log tidak dapat ditemui',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView(
              physics: const BouncingScrollPhysics(),
              children: snapshot.data!.docs.map((doc) {
                DateTime dt = (doc['timeStamp'] as Timestamp).toDate();
                String date =
                    DateFormat('dd-MM-yyyy | hh:mm a').format(dt).toString();
                bool isError = doc['isError'];
                return ListTile(
                  leading:
                      Icon(isError == true ? Icons.report_problem : Icons.done),
                  title: Text(doc['Repair Log']),
                  subtitle: Text(date),
                );
              }).toList(),
            );
          }),
    );
  }
}
