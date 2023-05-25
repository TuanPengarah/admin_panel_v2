import 'dart:convert';

import 'package:admin_panel/price_list/model/pricelist_field.dart';

class PriceListModel {
  String model;
  String parts;
  int id;
  int harga;

  PriceListModel(
      {required this.model,
      required this.parts,
      required this.harga,
      required this.id});

  // factory PriceListModel.fromJson(dynamic json) {
  //   return PriceListModel(
  //     model: json['model'],
  //     parts: json['parts'],
  //     harga: json['harga'],
  //     id: json['id'],
  //   );
  // }

  factory PriceListModel.fromJsonSqlite(dynamic json) {
    return PriceListModel(
      id: json['id'],
      model: json['model'],
      parts: json['parts'],
      harga: json['price'],
    );
  }

  static PriceListModel fromJson(Map<String, dynamic> json) => PriceListModel(
        id: jsonDecode(json[PriceListField.id]),
        model: json[PriceListField.model],
        parts: json[PriceListField.parts],
        harga: jsonDecode(json[PriceListField.harga]),
      );

  Map<String, dynamic> toJson() => {
        PriceListField.id: id,
        PriceListField.model: model,
        PriceListField.parts: parts,
        PriceListField.harga: harga,
      };

  Map<String, dynamic> toJsonSQlite() => {
        'id': id,
        'model': model,
        'parts': parts,
        'price': harga,
      };

  // {};

  // String addParams() {
  //   return '?model=$model&parts=$parts&price=$harga&id=$id';
  // }

  // String deleteParams() {
  //   return '?id=${id.toString()}';
  // }
}
