import 'dart:ui';
import 'package:admin_panel/cust_overview/controller/overview_controller.dart';
import 'package:admin_panel/cust_overview/view/model/popupmenu_overview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerInfoPage extends StatelessWidget {
  final _data = Get.arguments;
  final _overviewController = Get.find<OverviewController>();

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: _data[0],
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(_data[1]),
              background: _data[2] == ''
                  ? Container()
                  : Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
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
              PopupMenuButton<IconMenuOverview>(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
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
                        child: Ink(
                          width: double.infinity,
                          height: 190,
                          child: InkWell(
                            onTap: () {},
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
                      infoCard(
                        title: 'ID Pengguna',
                        subtitle: _data[0],
                        icon: Icons.badge,
                        pressed: () =>
                            _overviewController.launchWhatsapp(_data[3]),
                      ),
                      infoCard(
                        title: 'Nombor Telefon',
                        subtitle: _data[3],
                        icon: Icons.phone,
                        pressed: () =>
                            _overviewController.launchCaller(_data[3]),
                      ),
                      infoCard(
                        title: 'Email',
                        subtitle: _data[4],
                        icon: Icons.email,
                        pressed: () =>
                            _overviewController.launchEmail(_data[4], _data[1]),
                      ),
                      infoCard(
                        title: 'Repair Points',
                        subtitle: _data[5].toString(),
                        icon: Icons.toll,
                        pressed: () => _overviewController.launchSms(_data[3]),
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Card infoCard(
      {String title, String subtitle, IconData icon, Function pressed}) {
    return Card(
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
