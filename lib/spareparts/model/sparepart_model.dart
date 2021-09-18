import 'package:flutter/material.dart';

class Spareparts {
  final int id;
  final String model;
  final String jenisSpareparts;
  final String supplier;
  final String kualiti;
  final String maklumatSpareparts;
  final String tarikh;
  final String harga;
  final String partsID;

  Spareparts({
    this.id,
    @required this.model,
    @required this.jenisSpareparts,
    @required this.supplier,
    @required this.kualiti,
    @required this.maklumatSpareparts,
    @required this.tarikh,
    @required this.harga,
    @required this.partsID,
  });

  factory Spareparts.fromMap(Map<String, dynamic> json) => new Spareparts(
        id: json['id'],
        model: json['model'],
        jenisSpareparts: json['jenisParts'],
        supplier: json['supplier'],
        kualiti: json['kualitiParts'],
        maklumatSpareparts: json['maklumatParts'],
        tarikh: json[''],
        harga: json['harga'],
        partsID: json['id'],
      );

  toJson() {
    return {
      'Model': model,
      'Jenis Spareparts': jenisSpareparts,
      'Supplier': supplier,
      'Kualiti': kualiti,
      'Maklumat Spareparts': maklumatSpareparts,
      'Tarikh': tarikh,
      'Harga': harga,
      'id': partsID,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'model': model,
      'jenisParts': jenisSpareparts,
      'supplier': supplier,
      'kualitiParts': kualiti,
      'maklumatParts': maklumatSpareparts,
      'harga': harga,
      'tarikh': '',
      'partsID': partsID,
    };
  }
}
