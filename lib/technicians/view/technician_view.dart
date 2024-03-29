import 'package:admin_panel/auth/controller/firebase_auth_controller.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/technicians/controller/technician_controller.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

class TechnicianView extends StatelessWidget {
  final _data = Get.arguments;
  final _authController = Get.find<AuthController>();

  TechnicianView({super.key});
  @override
  Widget build(BuildContext context) {
    final technicianController = Get.put(TechnicianController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Juruteknik'),
        actions: [
          _authController.jawatan.value.contains('Founder')
              ? IconButton(
                  onPressed: () => Get.toNamed(MyRoutes.technicianAdd),
                  icon: const Icon(Icons.add),
                )
              : const SizedBox(),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
            // onPressed:{} _technicianController.getTechnician,
          )
        ],
      ),
      body: FutureBuilder(
        future: technicianController.getTechList,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (technicianController.technicians.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(15.0),
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
                physics: const BouncingScrollPhysics(),
                itemCount: technicianController.technicians.length,
                itemBuilder: (BuildContext context, int i) {
                  var technician = technicianController.technicians[i];
                  return AnimationConfiguration.staggeredList(
                    position: i,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: ListTile(
                          leading: AdvancedAvatar(
                            name: technician.nama,
                            size: 40,
                            image: ExtendedNetworkImageProvider(
                                technician.photoURL,
                                cache: true),
                            decoration: BoxDecoration(
                              color: Get.theme.primaryColor,
                              borderRadius: BorderRadius.circular(200),
                            ),
                          ),
                          title: Text(technician.nama),
                          subtitle: Text(technician.jawatan),
                          onTap: () {
                            if (_data == null) {
                              technicianController.techInfo(i);
                            } else {
                              var result = {
                                'nama': technician.nama,
                                'id': technician.id,
                              };

                              Get.back(result: result);
                            }
                          },
                        ),
                      ),
                    ),
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
