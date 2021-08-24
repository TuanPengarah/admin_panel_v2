import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/home/controller/customer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerPage extends StatelessWidget {
  final _customerController = Get.put(CustomerController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => _customerController.isSearch.value == false
              ? Text('Pelanggan')
              : TextField(
                  controller: _customerController.searchController,
                  autofocus: true,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  onChanged: (text) => _customerController.getCustomerDetails(),
                  decoration: InputDecoration(
                    hoverColor: Colors.white,
                    hintText: 'Cari Pelanggan...',
                    hintStyle: TextStyle(color: Colors.white60),
                    filled: false,
                    border: UnderlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(),
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
          IconButton(
            onPressed: () => _customerController.sorting(),
            icon: Icon(Icons.sort_by_alpha),
          ),
          IconButton(
            onPressed: () {},
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
              : Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await _customerController.getCustomerDetails();
                          Haptic.feedbackSuccess();
                        },
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: _customerController.customerList.length,
                          itemBuilder: (BuildContext context, int i) {
                            var customer = _customerController.customerList[i];
                            return ListTile(
                              onTap: () {},
                              title: Text(customer['Nama']),
                              subtitle: Text(customer['No Phone']),
                            );
                          },
                        ),
                      ),
                    ),
                    Obx(() => Text.rich(
                          TextSpan(
                            text: _customerController.isSearch.value == false
                                ? 'Jumlah keseluruhan pelanggan: '
                                : 'Jumlah pelanggan yang ditemui: ',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    '${_customerController.customerList.length}',
                                style: TextStyle(
                                  color: Get.theme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        )),
                    SizedBox(height: 5),
                  ],
                );
        },
      ),
    );
  }
}
