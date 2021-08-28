import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/home/model/customer_suggestion_model.dart';
import 'package:admin_panel/home/model/popupmenu_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerController extends GetxController {
  var isSearch = false.obs;
  var status = ''.obs;
  var descending = false.obs;
  String orderBy = 'Nama';
  final searchController = TextEditingController();
  final _firestore = FirebaseFirestore.instance.collection('customer');
  List customerList = [];
  List getFromFirestore = [];

  @override
  void onInit() {
    getCustomerDetails();
    super.onInit();
  }

  void sorting(IconMenu value) {
    // descending.value = !descending.value;
    // getCustomerDetails();
    // update();
    switch (value) {
      case PopupSortMenu.ascending:
        descending.value = false;
        Haptic.feedbackClick();
        orderBy = 'Nama';
        getCustomerDetails();
        update();
        break;
      case PopupSortMenu.descending:
        Haptic.feedbackClick();
        descending.value = true;
        orderBy = 'Nama';
        getCustomerDetails();
        update();
        break;
      case PopupSortMenu.time:
        Haptic.feedbackClick();
        orderBy = 'timeStamp';
        descending.value = true;
        getCustomerDetails();
        update();
        break;
    }
  }

  void clickSearch() {
    isSearch.value = !isSearch.value;
    if (isSearch.value == false) {
      searchController.text = '';
      getCustomerDetails();
    }
  }

  Future<void> getCustomerDetails() async {
    await _firestore
        .orderBy(orderBy, descending: descending.value)
        .get()
        .then((snapshot) {
      getFromFirestore = snapshot.docs;
      status.value = '';
      searchResultList();
      update();
      return 'Completed';
    }).catchError((err) {
      status.value = err.toString();
      print(err);
      return 'Error';
    });
  }

  void searchResultList() {
    var showResult = [];
    if (searchController.text != '') {
      // perform search
      for (var customerSnapshot in getFromFirestore) {
        var title = CustomerSuggestion.getCustomer(customerSnapshot)
            .title
            .toLowerCase();

        var noPhone = CustomerSuggestion.getCustomer(customerSnapshot)
            .phoneNumber
            .toLowerCase();

        if (title.contains(searchController.text.toLowerCase())) {
          showResult.add(customerSnapshot);
        } else if (noPhone.contains(searchController.text.toLowerCase())) {
          showResult.add(customerSnapshot);
        }
      }
    } else {
      showResult = List.from(getFromFirestore);
    }
    customerList = showResult;
    update();
  }
}
