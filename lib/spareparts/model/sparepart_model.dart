class Spareparts {
  final String key;
  final String model;
  final String jenisSpareparts;
  final String supplier;
  final String kualiti;
  final String maklumatSpareparts;
  final String tarikh;
  final String harga;
  final String id;

  Spareparts(
    this.key,
    this.model,
    this.jenisSpareparts,
    this.supplier,
    this.kualiti,
    this.maklumatSpareparts,
    this.tarikh,
    this.harga,
    this.id,
  );

  // Spareparts.fromSnapshot(DataSnapshot snapshot)
  //     : key = snapshot.key,
  //       model = snapshot.value['Model'],
  //       jenisSpareparts = snapshot.value['Jenis Spareparts'],
  //       supplier = snapshot.value['Supplier'],
  //       kualiti = snapshot.value['Kualiti'],
  //       maklumatSpareparts = snapshot.value['Maklumat Spareparts'],
  //       tarikh = snapshot.value['Tarikh'],
  //       harga = snapshot.value['Harga'];

  toJson() {
    return {
      'Model': model,
      'Jenis Spareparts': jenisSpareparts,
      'Supplier': supplier,
      'Kualiti': kualiti,
      'Maklumat Spareparts': maklumatSpareparts,
      'Tarikh': tarikh,
      'Harga': harga,
      'id': id,
    };
  }
}
