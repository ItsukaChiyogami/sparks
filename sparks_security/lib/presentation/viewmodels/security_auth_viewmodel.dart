import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SecurityAuthState {
  final bool isLoading;
  final String? error;
  final String? fullName; // 🟢 Tambahan penampung nama
  final String? nip;      // 🟢 Tambahan penampung NIP

  SecurityAuthState({
    this.isLoading = false, 
    this.error,
    this.fullName,
    this.nip,
  });

  SecurityAuthState copyWith({
    bool? isLoading, 
    String? error,
    String? fullName,
    String? nip,
  }) {
    return SecurityAuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      fullName: fullName ?? this.fullName,
      nip: nip ?? this.nip,
    );
  }
}

class SecurityAuthViewModel extends StateNotifier<SecurityAuthState> {
  SecurityAuthViewModel() : super(SecurityAuthState());

  final String _apiUrl = 'http://localhost:8080/api/auth/login';

  Future<bool> login(String nip, String password) async {
    if (nip.trim().isEmpty || password.trim().isEmpty) {
      state = state.copyWith(
        isLoading: false, 
        error: 'NIP dan password tidak boleh kosong.',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'identifier': nip, 
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // 🟢 Login Sukses: Map data dari database ke State Riverpod
        state = SecurityAuthState(
          isLoading: false,
          fullName: responseData['fullName'] ?? 'No Name',
          nip: nip, // Menggunakan parameter NIP inputan yang berhasil divalidasi
        );
        return true;
      } else {
        final String errorMessage = responseData['message'] ?? 'Terjadi kesalahan pada server.';
        state = state.copyWith(isLoading: false, error: errorMessage);
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false, 
        error: 'Gagal terhubung ke server. Pastikan backend aktif.',
      );
      return false;
    }
  }
}

final securityAuthProvider =
    StateNotifierProvider<SecurityAuthViewModel, SecurityAuthState>((ref) {
  return SecurityAuthViewModel();
});