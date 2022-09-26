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
