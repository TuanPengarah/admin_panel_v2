import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/technicians/controller/technician_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:get/get.dart';

class TechnicianView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _technicianController = Get.put(TechnicianController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Semua Juruteknik'),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(MyRoutes.technicianAdd),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _technicianController.getTechList,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (_technicianController.technicians.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_off,
                      color: Colors.grey,
                      size: 120,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Maaf anda tidak mempunyai sebarang staff dan technician huhuu',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }
          return GetBuilder<TechnicianController>(
            assignId: true,
            builder: (logic) {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _technicianController.technicians.length,
                itemBuilder: (BuildContext context, int i) {
                  var technician = _technicianController.technicians[i];
                  return ListTile(
                    leading: AdvancedAvatar(
                      name: '${technician['nama']}',
                      size: 40,
                      image: technician['photoURL'] == null ||
                          technician['photoURL'] == ''
                          ? null
                          : NetworkImage(technician['photoURL']),
                      decoration: BoxDecoration(
                        color: Get.theme.primaryColor,
                        borderRadius: BorderRadius.circular(200),
                      ),
                    ),
                    title: Text('${technician['nama']}'),
                    subtitle: Text('${technician['jawatan']}'),
                    onTap: () => _technicianController.techInfo(i),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
