import 'package:flutter/foundation.dart';

class InvoiceModel {
  final String title;
  final double price;
  final String warranty;

  InvoiceModel({
    @required this.title,
    @required this.price,
    @required this.warranty,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'warranty': warranty,
    };
  }
}

class InvoiceDetailsModel {
  final List invoiceList;
  final String custUID;
  final bool ispay;
  final String technician;

  InvoiceDetailsModel({
    @required this.invoiceList,
    @required this.custUID,
    @required this.ispay,
    @required this.technician,
  });

  factory InvoiceDetailsModel.fromDatabase(Map<dynamic, dynamic> json) {
    return InvoiceDetailsModel(
      technician: json['technician'],
      invoiceList: json['InvoiceList'],
      custUID: json['customerUID'],
      ispay: json['isPay'],
    );
  }
}
