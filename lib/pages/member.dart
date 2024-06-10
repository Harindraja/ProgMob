class Member {
  final String nomor_induk;
  final String nama;
  final String alamat;
  final String tgl_lahir;
  final String telepon;

  Member({
    required this.nomor_induk,
    required this.nama,
    required this.alamat,
    required this.tgl_lahir,
    required this.telepon,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      nomor_induk: json['nomor_induk'],
      nama: json['nama'],
      alamat: json['alamat'],
      tgl_lahir: json['tgl_lahir'],
      telepon: json['telepon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nomor_induk': nomor_induk,
      'nama': nama,
      'alamat': alamat,
      'tgl_lahir': tgl_lahir,
      'telepon': telepon,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
