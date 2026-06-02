class UserModel {
  final String fullName;
  final String nim;
  final String? vehiclePlate;
  final String? photoUrl;

  UserModel({
    required this.fullName,
    required this.nim,
    this.vehiclePlate,
    this.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['fullName'] ?? 'No Name',
      nim: json['nim'] ?? '',             // 🟢 Membaca field 'nim' dari LoginResponse Java
      vehiclePlate: json['vehiclePlate'], // 🟢 Membaca field 'vehiclePlate' dari LoginResponse Java
      photoUrl: json['photoUrl'],
    );
  }
}