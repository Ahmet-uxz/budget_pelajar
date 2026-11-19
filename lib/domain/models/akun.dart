class Akun {
  final String email;
  final String password;
  final String nama;
  final String noHp;

  const Akun({
    required this.email,
    required this.password,
    required this.nama,
    required this.noHp,
  });

  factory Akun.fromJson(Map<String, dynamic> json) => Akun(
    email: json['email'] as String,
    password: json['password'] as String,
    nama: json['nama'] as String,
    noHp: json['noHp'] as String,
  );

  Akun copyWith({String? nama, String? noHp}) => Akun(
    email: email,
    password: password,
    nama: nama ?? this.nama,
    noHp: noHp ?? this.noHp,
  );
}