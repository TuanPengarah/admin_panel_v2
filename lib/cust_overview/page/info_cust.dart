import 'dart:ui';
import 'package:admin_panel/cust_overview/controller/overview_controller.dart';
import 'package:admin_panel/cust_overview/model/popupmenu_overview.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerInfoPage extends StatelessWidget {
  final _data = Get.arguments;
  final _overviewController = Get.find<OverviewController>();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          expandedHeight: 180.0,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Obx(() => Text(_overviewController.customerName.value)),
            background: _data[2] == ''
                ? Container()
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      ExtendedImage.network(
                        _data[2],
                        fit: BoxFit.cover,
                        colorBlendMode: BlendMode.darken,
                      ),
                      ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            color: Colors.black45,
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
                          _overviewController.saveUserData(_data[0]),
                      icon: Icon(
                        Icons.save,
                      ),
                    )
                  : PopupMenuButton<IconMenuOverview>(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onSelected: (value) => _overviewController
                          .popupMenuSelected(value, _data[0], _data[1]),
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
                              _data[1], _data[3], _data[4], _data[0]),
                          borderRadius: BorderRadius.circular(25),
                          child: Column(
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
                          subtitle: _data[1] == ''
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
                          subtitle: _data[3] == ''
                              ? '--'
                              : _overviewController.noPhone.value,
                          icon: _overviewController.isEdit.value == true
                              ? Icons.edit
                              : Icons.phone,
                          pressed: () {
                            if (_overviewController.isEdit.value != true) {
                              _overviewController.showSheet(_data[3]);
                            } else {
                              _overviewController.editPhone();
                            }
                          }),
                    ),
                    infoCard(
                      title: 'Email',
                      subtitle: _data[4] == '' ? '--' : _data[4],
                      icon: Icons.email,
                      pressed: () =>
                          _overviewController.launchEmail(_data[4], _data[1]),
                    ),
                    infoCard(
                      title: 'Repair Points',
                      subtitle: _data[5].toString(),
                      icon: Icons.toll,
                      pressed: () {},
                    ),
                    infoCard(
                      title: 'ID Pengguna',
                      subtitle: _data[0],
                      icon: Icons.badge,
                      pressed: () => _overviewController.copyUID(_data[0]),
                    ),
                    SizedBox(height: 30),
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
    String title,
    String subtitle,
    IconData icon,
    Function pressed,
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
