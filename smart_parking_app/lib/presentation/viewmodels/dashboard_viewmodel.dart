import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/parking_slot_model.dart';

class DashboardState {
  final List<ParkingSlot> slots;
  final bool isLoading;
  final double vehicleWidthCm; // lebar kendaraan estimasi
  final double parkingWidthCm; // lebar area parkir total

  DashboardState({
    this.slots = const [],
    this.isLoading = false,
    this.vehicleWidthCm = 60.0,
    this.parkingWidthCm = 180.0,
  });

  DashboardState copyWith({
    List<ParkingSlot>? slots,
    bool? isLoading,
    double? vehicleWidthCm,
    double? parkingWidthCm,
  }) {
    return DashboardState(
      slots: slots ?? this.slots,
      isLoading: isLoading ?? this.isLoading,
      vehicleWidthCm: vehicleWidthCm ?? this.vehicleWidthCm,
      parkingWidthCm: parkingWidthCm ?? this.parkingWidthCm,
    );
  }

  /// Slot yang sudah terisi
  List<ParkingSlot> get occupiedSlots =>
      slots.where((s) => !s.isAvailable).toList();

  /// Lebar sisa setelah kendaraan terisi (cm)
  double get remainingWidthCm {
    final used = occupiedSlots.length * vehicleWidthCm;
    final remaining = parkingWidthCm - used;
    return remaining < 0 ? 0 : remaining;
  }

  /// Estimasi slot tersisa berdasarkan sisa lebar
  int get estimatedRemainingSlots =>
      (remainingWidthCm / vehicleWidthCm).floor();

  int get totalSlots => slots.length;
}

class DashboardViewModel extends StateNotifier<DashboardState> {
  DashboardViewModel() : super(DashboardState()) {
    _loadSlots();
  }

  void _loadSlots() {
    // Dummy data — ganti dengan API/sensor call nanti
    // 3 motor terisi (index 0,1,2), sisanya available
    final dummySlots = List.generate(5, (index) {
      return ParkingSlot(
        id: 'LOT-${(index + 1).toString().padLeft(3, '0')}',
        zone: 'Zone A',
        isAvailable: index >= 3,
      );
    });

    state = state.copyWith(slots: dummySlots);
  }
}

final dashboardProvider =
    StateNotifierProvider<DashboardViewModel, DashboardState>((ref) {
  return DashboardViewModel();
});