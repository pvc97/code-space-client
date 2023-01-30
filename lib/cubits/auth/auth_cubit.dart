import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:code_space_client/data/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({
    required this.authRepository,
  }) : super(AuthState.authenticated());

  void login({required String username, required String password}) async {
    try {
      final user = await authRepository.login(
        userName: username,
        password: password,
      );

      // Save user to local storage
      authRepository.saveUser(user);

      emit(state.copyWith(authStatus: AuthStatus.authenticated));
    } catch (e) {
      emit(
        state.copyWith(authStatus: AuthStatus.unauthenticated),
      );
    }
  }

  Future<void> logout() async {
    await authRepository.logout();
    emit(state.copyWith(authStatus: AuthStatus.unauthenticated));
  }

  void checkAuth() async {
    final isLoggedIn = await authRepository.isLoggedIn();

    if (isLoggedIn) {
      emit(state.copyWith(authStatus: AuthStatus.authenticated));
    } else {
      emit(state.copyWith(authStatus: AuthStatus.unauthenticated));
    }
  }
}
