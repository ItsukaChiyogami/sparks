import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../data/models/user_model.dart';

class AuthState {
  final bool rememberMe;
  final bool isLoading;
  final String? error;
  final UserModel? user; 

  AuthState({
    this.rememberMe = false,
    this.isLoading = false,
    this.error,
    this.user,
  });

  AuthState copyWith({
    bool? rememberMe,
    bool? isLoading,
    String? error,
    UserModel? user,
  }) {
    return AuthState(
      rememberMe: rememberMe ?? this.rememberMe,
      isLoading: isLoading ?? this.isLoading,
      error: error, 
      user: user ?? this.user,
    );
  }
}

class AuthViewModel extends StateNotifier<AuthState> {
  AuthViewModel() : super(AuthState());

  final String _apiUrl = 'http://localhost:8080/api/auth/login';

  void toggleRememberMe(bool value) {
    state = state.copyWith(rememberMe: value);
  }

  Future<bool> login(String nim, String password) async {
    if (nim.trim().isEmpty || password.trim().isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'NIM dan password tidak boleh kosong.',
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
          'identifier': nim.trim(), 
          'password': password.trim(),
        }),
      ).timeout(const Duration(seconds: 10));

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // 🟢 Memetakan data response secara dinamis tanpa hardcode plat nomor lagi
        final loggedInUser = UserModel(
          fullName: responseData['fullName'] ?? 'No Name',
          nim: nim.trim(),            
          vehiclePlate: responseData['vehiclePlate'] ?? 'Belum Diatur', 
        );

        state = state.copyWith(
          isLoading: false,
          user: loggedInUser,
          error: null,
        );
        return true;
      } else {
        final String errorMessage = responseData['message'] ?? 'NIM atau password salah.';
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

  void logout() {
    state = AuthState(rememberMe: state.rememberMe, user: null, error: null, isLoading: false);
  }
}

final authProvider = StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  return AuthViewModel();
});