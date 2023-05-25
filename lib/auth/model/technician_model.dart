class Technician {
  final String nama;
  final String cawangan;
  final String email;
  final int jumlahRepair;
  final int jumlahKeuntungan;
  final String jawatan;
  final String photoURL;
  final String? id;
  final int? uid;
  final String? token;

  Technician({
    this.id,
    this.uid,
    required this.nama,
    required this.cawangan,
    required this.email,
    required this.jumlahRepair,
    required this.jumlahKeuntungan,
    required this.jawatan,
    required this.photoURL,
    required this.token,
  });

  factory Technician.fromJson(Map<dynamic, dynamic> json) {
    return Technician(
      nama: json['nama'] as String,
      cawangan: json['cawangan'] as String,
      email: json['email'] as String,
      jumlahRepair: int.parse(json['jumlahRepair'].toString()),
      jumlahKeuntungan: int.parse(json['jumlahKeuntungan'].toString()),
      jawatan: json['jawatan'],
      photoURL: json['photoURL'],
      token: json['token'],
      uid: 0,
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'nama': nama.toString(),
        'cawangan': cawangan.toString(),
        'jumlahRepair': jumlahRepair,
        'jumlahKeuntungan': jumlahKeuntungan,
        'email': email.toString(),
        'photoURL': photoURL.toString(),
        'jawatan': jawatan.toString(),
        'id': id.toString(),
        'token': token.toString(),
      };
}
