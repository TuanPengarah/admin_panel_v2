import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/home/controller/customer_controller.dart';
import 'package:admin_panel/home/model/popupmenu_model.dart';
import 'package:admin_panel/sms/controller/sms_controller.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../controller/customer_search.dart';

class CustomerPage extends StatelessWidget {
  final isGrab;
  CustomerPage(this.isGrab);
  final _customerController = Get.find<CustomerController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              expandedHeight: 150,
              centerTitle: false,
              leading: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_outlined),
                  Text(
                    '${_customerController.customerListRead.value}',
                    style: TextStyle(fontSize: 10),
                  )
                ],
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                title: Text(
                  'Pelanggan',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inverseSurface),
                ),
              ),
              actions: [
                Obx(
                  () => IconButton(
                    onPressed: () {
                      showSearch(context: context, delegate: CustomerSearch());
                    },
                    icon: Icon(
                      _customerController.isSearch.value == false
                          ? Icons.search
                          : Icons.close,
                    ),
                  ),
                ),
                PopupMenuButton<IconMenu>(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  icon: Icon(Icons.sort),
                  onSelected: (value) {
                    _customerController.sorting(value);
                    _customerController.currentlySelected = value.text;
                    _customerController.box.write('sortCustomer', value.text);
                  },
                  itemBuilder: (context) => PopupSortMenu.items
                      .map(
                        (i) => PopupMenuItem<IconMenu>(
                          value: i,
                          child: ListTile(
                            leading: Icon(
                              i.icon,
                              color: _customerController.currentlySelected ==
                                      i.text
                                  ? Get.theme.iconTheme.color
                                  : Colors.grey,
                            ),
                            title: Text(
                              i.text,
                              style: TextStyle(
                                  color:
                                      _customerController.currentlySelected ==
                                              i.text
                                          ? Get.theme.textTheme.bodyLarge.color
                                          : Colors.grey,
                                  fontWeight:
                                      _customerController.currentlySelected ==
                                              i.text
                                          ? FontWeight.bold
                                          : FontWeight.normal),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                isGrab == false
                    ? IconButton(
                        onPressed: () {
                          Haptic.feedbackClick();
                          Get.toNamed(MyRoutes.jobsheet,
                              arguments: [false, '', '', '', '']);
                        },
                        icon: Icon(
                          Icons.add,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ];
        },
        body: GetBuilder<CustomerController>(builder: (_) {
          return FutureBuilder(
              future: _customerController.getCust,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: 20,
                      itemBuilder: (context, i) {
                        return Shimmer.fromColors(
                          baseColor: Get.isDarkMode
                              ? Colors.grey[900]
                              : Colors.black26,
                          highlightColor: Get.isDarkMode
                              ? Colors.grey[700]
                              : Colors.grey.shade400,
                          child: ListTile(
                            leading: CircleAvatar(),
                            title: Container(
                              height: 10,
                              width: double.infinity,
                              color: Colors.grey[50],
                            ),
                            subtitle: Container(
                              height: 8,
                              width: 35,
                              color: Colors.grey[50],
                            ),
                          ),
                        );
                      });
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            'Uh Oh! Kesalahan telah berlaku:\n${_customerController.status.value}',
                            textAlign: TextAlign.center),
                        TextButton(
                          onPressed: () async {
                            await _customerController.getCustomerDetails();
                            Haptic.feedbackSuccess();
                          },
                          child: Text(
                            'Muat Semula',
                          ),
                        )
                      ],
                    ),
                  );
                }
                if (_customerController.customerList.isEmpty) {
                  return Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_search, size: 150, color: Colors.grey),
                      SizedBox(height: 10),
                      Text(
                        'Pelanggan tidak dapat ditemui!',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ));
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await _customerController.getCustomerDetails();
                    Haptic.feedbackSuccess();
                  },
                  child: ListView.builder(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    itemCount: _customerController.customerList.length,
                    itemBuilder: (BuildContext context, int i) {
                      var customer = _customerController.customerList[i];
                      var image = customer['photoURL'];
                      return customerTiles(customer, image);
                    },
                  ),
                );
              });
        }),
      ),
    );
  }

  Slidable customerTiles(customer, image) {
    return Slidable(
      startActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            backgroundColor: Get.theme.colorScheme.primaryContainer,
            foregroundColor: Get.theme.colorScheme.onPrimaryContainer,
            label: 'Hubungi',
            icon: Icons.phone,
            onPressed: (_) {
              _customerController.launchCaller(customer['No Phone']);
            },
          ),
          SlidableAction(
              backgroundColor: Get.theme.colorScheme.onPrimaryContainer,
              foregroundColor: Get.theme.colorScheme.primaryContainer,
              label: 'Mesej',
              icon: Icons.sms,
              onPressed: (_) {
                _customerController.launchSms(customer['No Phone']);
              }),
        ],
      ),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            backgroundColor: Get.theme.colorScheme.tertiaryContainer,
            foregroundColor: Get.theme.colorScheme.tertiary,
            label: 'Jobsheet',
            icon: Icons.receipt_long,
            onPressed: (_) => _customerController.addToJobsheet(
                customer['Nama'],
                customer['No Phone'],
                customer['Email'],
                customer['UID']),
          ),
          SlidableAction(
              backgroundColor: Get.theme.colorScheme.onErrorContainer,
              foregroundColor: Get.theme.colorScheme.onError,
              label: 'Buang',
              icon: Icons.delete,
              onPressed: (_) {
                Haptic.feedbackError();
                _customerController.deleteUser(
                    customer['UID'], customer['Nama']);
              })
        ],
      ),
      child: ListTile(
        onTap: () {
          if (isGrab == false) {
            Haptic.feedbackClick();
            Get.toNamed(
              MyRoutes.overview,
              // arguments: [
              //   customer['UID'],
              //   customer['Nama'],
              //   customer['photoURL'],
              //   customer['No Phone'],
              //   customer['Email'],
              //   customer['Points'],
              //   customer['timeStamp'],
              // ],
              arguments: {
                'UID': customer['UID'],
                'Nama': customer['Nama'],
                'photoURL': customer['photoURL'],
                'No Phone': customer['No Phone'],
                'Email': customer['Email'],
                'Points': customer['Points'],
                'timeStamp': customer['timeStamp']
              },
            );
          } else {
            final smsController = Get.put(SMSController());
            if (smsController.recipientText.text == '') {
              smsController.recipientText.text += '6${customer['No Phone']}';
            } else {
              smsController.recipientText.text += ',6${customer['No Phone']}';
            }

            Get.back();
          }
        },
        leading: Hero(
          tag: customer['UID'],
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: AdvancedAvatar(
              size: 35,
              name: customer['Nama'],
              image: ExtendedNetworkImageProvider(image),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(200),
              ),
              style: TextStyle(
                color: Get.theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        title: Text(customer['Nama']),
        subtitle:
            Text(customer['No Phone'] == '' ? '--' : customer['No Phone']),
      ),
    );
  }
}
