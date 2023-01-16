import 'dart:convert';

import 'package:code_space_client/constants/spref_key.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:code_space_client/data/local/local_storage_manager.dart';
import 'package:code_space_client/models/user_model.dart';
import 'package:code_space_client/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  final LocalStorageManager localStorage;

  AuthCubit({
    required this.authRepository,
    required this.localStorage,
  }) : super(AuthState.authenticated());

  void login({required String username, required String password}) async {
    try {
      final user = await authRepository.login(
        userName: username,
        password: password,
      );

      // Save user to local storage
      await localStorage.write<String>(
          SPrefKey.userModel, jsonEncode(user.toJson()));

      emit(
        state.copyWith(
          user: user,
          authStatus: AuthStatus.authenticated,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          user: null,
          authStatus: AuthStatus.unauthenticated,
        ),
      );
    }
  }

  void logout() async {
    localStorage.deleteAll();

    emit(
      state.copyWith(
        user: null,
        authStatus: AuthStatus.unauthenticated,
      ),
    );
  }

  void checkAuth() async {
    final listData = await Future.wait([
      localStorage.read<String>(SPrefKey.userModel),
      localStorage.read<String>(SPrefKey.tokenModel),
    ]);
    final userJson = listData[0];
    final tokenJson = listData[1];

    if (userJson == null || tokenJson == null) {
      await localStorage.deleteAll();
      emit(
        state.copyWith(
          user: null,
          authStatus: AuthStatus.unauthenticated,
        ),
      );
      return;
    }

    final user = UserModel.fromJson(jsonDecode(userJson));
    emit(
      state.copyWith(
        user: user,
        authStatus: AuthStatus.authenticated,
      ),
    );
  }
}
