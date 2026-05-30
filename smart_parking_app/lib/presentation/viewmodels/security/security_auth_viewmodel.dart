import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecurityAuthState {
  final bool isLoading;
  final String? error;

  SecurityAuthState({this.isLoading = false, this.error});

  SecurityAuthState copyWith({bool? isLoading, String? error}) {
    return SecurityAuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class SecurityAuthViewModel extends StateNotifier<SecurityAuthState> {
  SecurityAuthViewModel() : super(SecurityAuthState());

  Future<bool> login(String nip, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(milliseconds: 800));
    // Ganti dengan API call nanti
    if (nip.isNotEmpty && password.isNotEmpty) {
      state = state.copyWith(isLoading: false);
      return true;
    }
    state = state.copyWith(isLoading: false, error: 'NIP atau password salah.');
    return false;
  }
}

final securityAuthProvider =
    StateNotifierProvider<SecurityAuthViewModel, SecurityAuthState>((ref) {
  return SecurityAuthViewModel();
});