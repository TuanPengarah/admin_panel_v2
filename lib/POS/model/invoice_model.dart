import 'package:flutter/foundation.dart';

class InvoiceModel {
  final String title;
  final double price;
  final String technician;
  final String warranty;
  final bool isPay;

  InvoiceModel({
    @required this.isPay,
    @required this.title,
    @required this.price,
    @required this.technician,
    @required this.warranty,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'technician': technician,
      'warranty': warranty,
      'isPay': isPay,
    };
  }
}
