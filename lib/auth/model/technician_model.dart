class Technician {
  final String nama;
  final String cawangan;
  final String email;
  final int jumlahRepair;
  final int jumlahKeuntungan;
  final String jawatan;
  final String photoURL;

  Technician(
    this.nama,
    this.cawangan,
    this.email,
    this.jumlahRepair,
    this.jumlahKeuntungan,
    this.jawatan,
    this.photoURL,
  );

  Technician.fromJson(Map<dynamic, dynamic> json)
      : nama = json['nama'] as String,
        cawangan = json['cawangan'] as String,
        email = json['email'] as String,
        jumlahRepair = json['jumlahRepair'] as int,
        jumlahKeuntungan = json['jumlahKeuntungan'] as int,
        jawatan = json['jawatan'],
        photoURL = json['photoURL'];

  Map<dynamic, dynamic> toJson() => {
        'nama': nama.toString(),
        'cawangan': cawangan.toString(),
        'jumlahRepair': jumlahRepair,
        'jumlahKeuntungan': jumlahKeuntungan,
        'email': email.toString(),
      };
}
