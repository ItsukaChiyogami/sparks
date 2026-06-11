import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../data/models/parked_vehicle_model.dart';

class LiveCamState {
  final List<ParkedVehicleModel> parkedVehicles;
  final int totalSlots;
  final int
      remainingSlots; // <--- Menggunakan nilai langsung dari server Python
  final bool alarmActive;
  final bool isLoading;

  LiveCamState({
    this.parkedVehicles = const [],
    this.totalSlots = 5,
    this.remainingSlots = 5, // Default awal disamakan dengan total slot
    this.alarmActive = false,
    this.isLoading = false,
  });

  LiveCamState copyWith({
    List<ParkedVehicleModel>? parkedVehicles,
    int? totalSlots,
    int? remainingSlots, // <--- Ditambahkan ke copyWith
    bool? alarmActive,
    bool? isLoading,
  }) {
    return LiveCamState(
      parkedVehicles: parkedVehicles ?? this.parkedVehicles,
      totalSlots: totalSlots ?? this.totalSlots,
      remainingSlots: remainingSlots ?? this.remainingSlots,
      alarmActive: alarmActive ?? this.alarmActive,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class LiveCamViewModel extends StateNotifier<LiveCamState> {
  Timer? _slotTimer;

  // Ganti URL ini sesuai dengan konfigurasi IP server Flask Anda
  final String _baseUrl = 'http://192.168.8.228:5000';

  LiveCamViewModel() : super(LiveCamState()) {
    _load();
    _startSlotPolling(); // <--- Menjalankan sinkronisasi slot real-time saat inisialisasi
  }

  void _load() {
    // TODO: Ganti dengan API call data motor terparkir jika sudah siap
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
          plate: 'D 3456 OZ', ownerName: 'Raditya Ilham', nim: '0806022310028'),
    ]);
  }

  // ── LOGIKA POLLING API SLOT PYTHON ───────────────────────────────────────
  void _startSlotPolling() {
    // Melakukan request ke Python setiap 2 detik sekali
    _slotTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      try {
        final response = await http.get(Uri.parse('$_baseUrl/api/slots'));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final serverRemainingSlots = data['remaining_slots'] as int;

          // Perbarui state secara real-time ke UI
          state = state.copyWith(remainingSlots: serverRemainingSlots);
        }
      } catch (e) {
        debugPrint("Gagal mengambil data sisa slot dari server: $e");
      }
    });
  }

  void toggleAlarm() {
    state = state.copyWith(alarmActive: !state.alarmActive);
  }

  @override
  void dispose() {
    _slotTimer
        ?.cancel(); // Menghentikan timer saat viewmodel dihancurkan agar tidak memory leak
    super.dispose();
  }
}

final liveCamProvider =
    StateNotifierProvider<LiveCamViewModel, LiveCamState>((ref) {
  return LiveCamViewModel();
});
