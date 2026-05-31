import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/parked_vehicle_model.dart';

class LiveCamState {
  final List<ParkedVehicleModel> parkedVehicles;
  final int totalSlots;
  final bool alarmActive;
  final bool isLoading;

  LiveCamState({
    this.parkedVehicles = const [],
    this.totalSlots = 5,
    this.alarmActive = false,
    this.isLoading = false,
  });

  int get remainingSlots => totalSlots - parkedVehicles.length;

  LiveCamState copyWith({
    List<ParkedVehicleModel>? parkedVehicles,
    int? totalSlots,
    bool? alarmActive,
    bool? isLoading,
  }) {
    return LiveCamState(
      parkedVehicles: parkedVehicles ?? this.parkedVehicles,
      totalSlots: totalSlots ?? this.totalSlots,
      alarmActive: alarmActive ?? this.alarmActive,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class LiveCamViewModel extends StateNotifier<LiveCamState> {
  LiveCamViewModel() : super(LiveCamState()) {
    _load();
  }

  void _load() {
    // TODO: ganti dengan API call
    state = state.copyWith(parkedVehicles: [
      ParkedVehicleModel(
          plate: 'B 2789 PZA',
          ownerName: 'Javin Erasmus Clementino',
          nim: '0806022310025'),
      ParkedVehicleModel(
          plate: 'DD 1580 IOG',
          ownerName: 'Aditya Ridwan',
          nim: '0806022310022'),
      ParkedVehicleModel(
          plate: 'D 3456 OZ',
          ownerName: 'Raditya Ilham',
          nim: '0806022310028'),
    ]);
  }

  void toggleAlarm() {
    state = state.copyWith(alarmActive: !state.alarmActive);
  }
}

final liveCamProvider =
    StateNotifierProvider<LiveCamViewModel, LiveCamState>((ref) {
  return LiveCamViewModel();
});