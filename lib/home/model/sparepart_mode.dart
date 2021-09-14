import 'package:firebase_database/firebase_database.dart';

class Spareparts {
  final String key;
  final String sparepart;
  final String type;
  final String supplier;
  final String manufactor;
  final String details;
  final String date;
  final String price;

  Spareparts(
    this.key,
    this.sparepart,
    this.type,
    this.supplier,
    this.manufactor,
    this.details,
    this.date,
    this.price,
  );

  Spareparts.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        sparepart = snapshot.value['Model'],
        type = snapshot.value['Jenis Spareparts'],
        supplier = snapshot.value['Supplier'],
        manufactor = snapshot.value['Kualiti'],
        details = snapshot.value['Maklumat Spareparts'],
        date = snapshot.value['Tarikh'],
        price = snapshot.value['Harga'];

  toJson() {
    return {
      'Model': sparepart,
      'Jenis Spareparts': type,
      'Supplier': supplier,
      'Kualiti': manufactor,
      'Maklumat Spareparts': details,
      'Tarikh': date,
      'Harga': price,
    };
  }
}
