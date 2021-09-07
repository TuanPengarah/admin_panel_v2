import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/home/controller/customer_controller.dart';
import 'package:admin_panel/home/model/popupmenu_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class CustomerPage extends StatelessWidget {
  final _customerController = Get.put(CustomerController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => _customerController.isSearch.value == false
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pelanggan'),
                    SizedBox(height: 3),
                    Text(
                      'Jumlah keseluruhan pelanggan: ${_customerController.customerListRead.value}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )
              : Theme(
                  data: Theme.of(context).copyWith(
                      textSelectionTheme: TextSelectionThemeData(
                          selectionColor: Colors.white54)),
                  child: TextField(
                    controller: _customerController.searchController,
                    autofocus: true,
                    style: TextStyle(color: Colors.white),
                    textInputAction: TextInputAction.search,
                    cursorColor: Colors.white,
                    onChanged: (text) =>
                        _customerController.getCustomerDetails(),
                    decoration: InputDecoration(
                      hoverColor: Colors.white,
                      focusColor: Colors.white,
                      fillColor: Colors.white,
                      hintText: 'Cari Pelanggan...',
                      hintStyle: TextStyle(color: Colors.white60),
                      filled: false,
                      border: UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(),
                    ),
                  ),
                ),
        ),
        actions: [
          Obx(
            () => IconButton(
              onPressed: () => _customerController.clickSearch(),
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
            onSelected: (value) => _customerController.sorting(value),
            itemBuilder: (context) => PopupSortMenu.items
                .map(
                  (i) => PopupMenuItem<IconMenu>(
                    value: i,
                    child: ListTile(
                      leading: Icon(i.icon),
                      title: Text(i.text),
                    ),
                  ),
                )
                .toList(),
          ),
          IconButton(
            onPressed: () {
              Haptic.feedbackClick();
              Get.toNamed(MyRoutes.jobsheet,
                  arguments: [false, '', '', '', '']);
            },
            icon: Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: GetBuilder<CustomerController>(
        builder: (_) {
          return _customerController.status.value != ''
              ? Center(
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
                )
              : _customerController.isSearch.value == true &&
                      _customerController.customerList.length == 0
                  ? Center(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_search,
                            size: 150, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          'Pelanggan tidak dapat ditemui!',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ))
                  : _customerController.customerList.length == 0
                      ? Scrollbar(
                          child: ListView.builder(
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
                              }),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            await _customerController.getCustomerDetails();
                            Haptic.feedbackSuccess();
                          },
                          child: Scrollbar(
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount:
                                  _customerController.customerList.length,
                              itemBuilder: (BuildContext context, int i) {
                                var customer =
                                    _customerController.customerList[i];
                                var image = customer['photoURL'];
                                return Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.25,
                                  child: ListTile(
                                    onTap: () {
                                      Haptic.feedbackClick();
                                      Get.toNamed(
                                        MyRoutes.overview,
                                        arguments: [
                                          customer['UID'],
                                          customer['Nama'],
                                          customer['photoURL'],
                                          customer['No Phone'],
                                          customer['Email'],
                                          customer['Points'],
                                          customer['timeStamp'],
                                        ],
                                      );
                                    },
                                    leading: Hero(
                                      tag: customer['UID'],
                                      child: SingleChildScrollView(
                                        physics: NeverScrollableScrollPhysics(),
                                        child: AdvancedAvatar(
                                          size: 35,
                                          name: customer['Nama'],
                                          image: image == ''
                                              ? null
                                              : NetworkImage(image),
                                          decoration: BoxDecoration(
                                            color: Get.theme.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: Text(customer['Nama']),
                                    subtitle: Text(customer['No Phone'] == ''
                                        ? '--'
                                        : customer['No Phone']),
                                  ),
                                  actions: [
                                    IconSlideAction(
                                      color: Colors.green,
                                      caption: 'Hubungi',
                                      icon: Icons.phone,
                                      onTap: () => _customerController
                                          .launchCaller(customer['No Phone']),
                                    ),
                                    IconSlideAction(
                                      color: Colors.amber[900],
                                      caption: 'Mesej',
                                      icon: Icons.sms,
                                      onTap: () => _customerController
                                          .launchSms(customer['No Phone']),
                                    ),
                                  ],
                                  secondaryActions: [
                                    IconSlideAction(
                                      color: Colors.blue,
                                      caption: 'Jobsheet',
                                      icon: Icons.receipt_long,
                                      onTap: () =>
                                          _customerController.addToJobsheet(
                                              customer['Nama'],
                                              customer['No Phone'],
                                              customer['Email'],
                                              customer['UID']),
                                    ),
                                    IconSlideAction(
                                      color: Colors.red,
                                      caption: 'Buang',
                                      icon: Icons.delete,
                                      onTap: () =>
                                          _customerController.deleteUser(
                                              customer['UID'],
                                              customer['Nama']),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        );
        },
      ),
    );
  }
}
