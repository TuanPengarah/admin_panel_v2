class Technician {
  final String nama;
  final String cawangan;
  final String email;
  final int jumlahRepair;
  final int jumlahKeuntungan;

  Technician(
    this.nama,
    this.cawangan,
    this.email,
    this.jumlahRepair,
    this.jumlahKeuntungan,
  );

  Technician.fromJson(Map<dynamic, dynamic> json)
      : nama = json['nama'] as String,
        cawangan = json['cawangan'] as String,
        email = json['email'] as String,
        jumlahRepair = json['jumlahRepair'] as int,
        jumlahKeuntungan = json['jumlahKeuntungan'] as int;

  Map<dynamic, dynamic> toJson() => {
        'nama': nama.toString(),
        'cawangan': cawangan.toString(),
        'jumlahRepair': jumlahRepair,
        'jumlahKeuntungan': jumlahKeuntungan,
        'email' : email.toString(),
      };
}
