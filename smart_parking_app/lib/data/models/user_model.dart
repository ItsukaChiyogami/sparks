class UserModel {
  final String fullName;
  final String nim;
  final String vehiclePlate;
  final String? photoUrl;

  UserModel({
    required this.fullName,
    required this.nim,
    required this.vehiclePlate,
    this.photoUrl,
  });
}