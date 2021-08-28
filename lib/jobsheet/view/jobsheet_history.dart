import 'package:admin_panel/API/sqlite.dart';
import 'package:admin_panel/jobsheet/controller/history_controller.dart';
import 'package:admin_panel/jobsheet/model/jobsheet_history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobsheetHistory extends StatelessWidget {
  final _historyController = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sejarah Jobsheet'),
      ),
      body: GetBuilder<HistoryController>(
        init: HistoryController(),
        builder: (_) {
          return Center(
            child: FutureBuilder<List<JobsheetHistoryModel>>(
              future: DatabaseHelper.instance.getHistory(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<JobsheetHistoryModel>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text('Memuatkan data...'),
                  );
                }
                return snapshot.data.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: 120,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Tiada sejarah Jobsheet ditemui!',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      )
                    : ListView(
                        children: snapshot.data.map((history) {
                          return ListTile(
                            title: Text(history.name),
                            subtitle: Text(history.noPhone),
                            onTap: () =>
                                _historyController.showDetails(history),
                          );
                        }).toList(),
                      );
              },
            ),
          );
        },
      ),
    );
  }
}
