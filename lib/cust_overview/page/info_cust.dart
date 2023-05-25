import 'dart:ui';
import 'package:admin_panel/cust_overview/controller/overview_controller.dart';
import 'package:admin_panel/cust_overview/model/popupmenu_overview.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerInfoPage extends StatelessWidget {
  final _data = Get.arguments;
  final _overviewController = Get.find<OverviewController>();

  CustomerInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 180.0,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Obx(
              () => Text(
                _overviewController.customerName.value,
                style: TextStyle(color: Get.theme.colorScheme.onSurfaceVariant),
              ),
            ),
            background: _data['photoURL'] == ''
                ? Container()
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      ExtendedImage.network(
                        _data['photoURL'],
                        fit: BoxFit.cover,
                        colorBlendMode: BlendMode.darken,
                      ),
                      ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            color: Get.isDarkMode
                                ? Colors.black54
                                : Colors.white60,
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          actions: [
            Obx(
              () => _overviewController.isEdit.value == true
                  ? IconButton(
                      onPressed: () =>
                          _overviewController.saveUserData(_data['UID']),
                      icon: const Icon(
                        Icons.save,
                      ),
                    )
                  : PopupMenuButton<IconMenuOverview>(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onSelected: (value) =>
                          _overviewController.popupMenuSelected(
                              value, _data['UID'], _data['Nama']),
                      itemBuilder: (context) => PopupMenuOverview.items
                          .map(
                            (i) => PopupMenuItem<IconMenuOverview>(
                              value: i,
                              child: ListTile(
                                  leading: Icon(i.icon), title: Text(i.text)),
                            ),
                          )
                          .toList(),
                    ),
            ),
          ],
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Card(
                      elevation: 2,
                      child: Ink(
                        width: double.infinity,
                        height: 190,
                        child: InkWell(
                          onTap: () => _overviewController.addToJobsheet(
                              _data['Nama'],
                              _data['No Phone'],
                              _data['Email'],
                              _data['UID']),
                          borderRadius: BorderRadius.circular(25),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.receipt_long, size: 70),
                              SizedBox(height: 10),
                              Text(
                                'Tambah Jobsheet untuk pelanggan ini',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => infoCard(
                          title: 'Nama Pelanggan',
                          subtitle: _data['Nama'] == ''
                              ? '--'
                              : _overviewController.customerName.value,
                          icon: _overviewController.isEdit.value == true
                              ? Icons.edit
                              : Icons.badge,
                          pressed: () {
                            if (_overviewController.isEdit.value == true) {
                              _overviewController.editUsername();
                            }
                          }),
                    ),
                    Obx(
                      () => infoCard(
                          title: 'Nombor Telefon',
                          subtitle: _data['No Phone'] == ''
                              ? '--'
                              : _overviewController.noPhone.value,
                          icon: _overviewController.isEdit.value == true
                              ? Icons.edit
                              : Icons.phone,
                          pressed: () {
                            if (_overviewController.isEdit.value != true) {
                              if (_data['No Phone'] != '') {
                                _overviewController.showSheet(
                                    _data['No Phone'], _data['Nama']);
                              }
                            } else {
                              _overviewController.editPhone();
                            }
                          }),
                    ),
                    infoCard(
                      title: 'Email',
                      subtitle: _data['Email'] == '' ? '--' : _data['Email'],
                      icon: Icons.email,
                      pressed: () => _overviewController.launchEmail(
                          _data['Email'], _data['Nama']),
                    ),
                    infoCard(
                      title: 'Repair Points',
                      subtitle: _data['Points'].toString(),
                      icon: Icons.toll,
                      pressed: () {},
                    ),
                    infoCard(
                      title: 'ID Pengguna',
                      subtitle: _data['UID'],
                      icon: Icons.badge,
                      pressed: () => _overviewController.copyUID(_data['UID']),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Card infoCard({
    String? title,
    String? subtitle,
    IconData? icon,
    Function()? pressed,
  }) {
    return Card(
      elevation: 2,
      child: Ink(
        child: InkWell(
          onTap: pressed ?? () {},
          borderRadius: BorderRadius.circular(25),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(icon ?? Icons.badge),
              title: Text(title ?? 'Tajuk'),
              subtitle: Text(subtitle ?? 'Maklumat'),
            ),
          ),
        ),
      ),
    );
  }
}
