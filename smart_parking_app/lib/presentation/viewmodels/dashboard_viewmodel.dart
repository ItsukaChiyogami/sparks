import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../data/models/parking_slot_model.dart';

class DashboardState {
  final List<ParkingSlot> slots;
  final bool isLoading;
  final double vehicleWidthCm; // <--- UBAH JADI 6.0 (30cm / 5 slot)
  final double parkingWidthCm; // <--- UBAH JADI 30.0

  DashboardState({
    this.slots = const [],
    this.isLoading = false,
    this.vehicleWidthCm = 6.0, // Estimasi lebar 1 motor sekarang 6 cm
    this.parkingWidthCm = 30.0, // Batas total lebar parkir sekarang 30 cm
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
      slots.where((s) => !s.isAvailable).toList(); //

  /// Lebar sisa setelah kendaraan terisi (cm)
  double get remainingWidthCm {
    final used = occupiedSlots.length * vehicleWidthCm; //
    final remaining = parkingWidthCm - used; //
    return remaining < 0 ? 0 : remaining; //
  }

  /// Estimasi slot tersisa berdasarkan sisa lebar
  int get estimatedRemainingSlots =>
      (remainingWidthCm / vehicleWidthCm).floor(); //

  int get totalSlots => slots.length; //
}

class DashboardViewModel extends StateNotifier<DashboardState> {
  Timer? _pollingTimer;

  // URL Server Python Flask Anda
  final String _baseUrl = 'http://192.168.8.228:5000';

  DashboardViewModel() : super(DashboardState()) {
    _startRealtimePolling(); // Jalankan sinkronisasi real-time saat inisialisasi
  }

  // ── LOGIKA POLLING REALTIME DARI PYTHON ──────────────────────────────
  void _startRealtimePolling() {
    // Meminta data sisa slot setiap 2 detik sekali
    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      try {
        final response = await http.get(Uri.parse('$_baseUrl/api/slots'));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final remainingSlotsFromServer = data['remaining_slots'] as int;

          int totalKapasitas = 5;
          // Menghitung berapa motor yang sedang terparkir
          int totalMotorTerisi = totalKapasitas - remainingSlotsFromServer;

          // Generate ulang list slots berdasarkan jumlah kendaraan yang terdeteksi
          final updatedSlots = List.generate(totalKapasitas, (index) {
            return ParkingSlot(
              id: 'LOT-${(index + 1).toString().padLeft(3, '0')}',
              zone: 'Zone A',
              // Jika index kurang dari jumlah motor terisi, set ketersediaan jadi false (terisi)
              isAvailable: index >= totalMotorTerisi,
            );
          });

          // Perbarui state, otomatis memicu update di halaman dashboard_page.dart
          state = state.copyWith(slots: updatedSlots);
        }
      } catch (e) {
        debugPrint("Dashboard gagal mengambil data real-time dari server: $e");
      }
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel(); // Mencegah kebocoran memori saat pindah halaman
    super.dispose();
  }
}

final dashboardProvider =
    StateNotifierProvider<DashboardViewModel, DashboardState>((ref) {
      return DashboardViewModel();
    });
