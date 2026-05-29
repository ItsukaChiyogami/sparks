import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';

class ProfileState {
  final UserModel? user;
  final bool isLoading;

  ProfileState({
    this.user,
    this.isLoading = false,
  });

  ProfileState copyWith({
    UserModel? user,
    bool? isLoading,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ProfileViewModel extends StateNotifier<ProfileState> {
  ProfileViewModel() : super(ProfileState()) {
    _loadProfile();
  }

  void _loadProfile() {
    // Dummy data — ganti dengan data sesi login nanti
    state = state.copyWith(
      user: UserModel(
        fullName: 'Andi Alfian Tenggara Putra',
        nim: '080602230025',
        vehiclePlate: 'B 2789 PZA',
        photoUrl: null, // ganti dengan URL foto dari API
      ),
    );
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 500));
    state = ProfileState(); // reset state
  }
}

final profileProvider =
    StateNotifierProvider<ProfileViewModel, ProfileState>((ref) {
  return ProfileViewModel();
});