class ParkedVehicleModel {
  final String plate;
  final String ownerName;
  final String nim;
  final String? photoUrl;

  ParkedVehicleModel({
    required this.plate,
    required this.ownerName,
    required this.nim,
    this.photoUrl,
  });
}