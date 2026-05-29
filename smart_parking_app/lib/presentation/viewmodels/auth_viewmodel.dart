import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool rememberMe;
  final bool isLoading;

  AuthState({
    this.rememberMe = false,
    this.isLoading = false,
  });

  AuthState copyWith({
    bool? rememberMe,
    bool? isLoading,
  }) {
    return AuthState(
      rememberMe: rememberMe ?? this.rememberMe,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthViewModel extends StateNotifier<AuthState> {
  AuthViewModel() : super(AuthState());

  void toggleRememberMe(bool value) {
    state = state.copyWith(rememberMe: value);
  }

  Future<void> login(String nim, String password) async {
    state = state.copyWith(isLoading: true);

    await Future.delayed(const Duration(seconds: 2));

    state = state.copyWith(isLoading: false);

    print("Login dengan NIM: $nim");
  }
}

final authProvider =
    StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  return AuthViewModel();
});