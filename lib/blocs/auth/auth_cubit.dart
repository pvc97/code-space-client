import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/models/app_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:code_space_client/data/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({
    required this.authRepository,
  }) : super(AuthState.unAuthenticated());

  void login({required String username, required String password}) async {
    try {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      await authRepository.login(
        userName: username,
        password: password,
      );
      emit(state.copyWith(
        authStatus: AuthStatus.authenticated,
        stateStatus: StateStatus.success,
      ));
    } on AppException catch (e) {
      emit(
        state.copyWith(
          authStatus: AuthStatus.unauthenticated,
          error: e,
          stateStatus: StateStatus.error,
        ),
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
