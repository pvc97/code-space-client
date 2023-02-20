import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/data/repositories/user_repository.dart';
import 'package:code_space_client/models/app_exception.dart';
import 'package:code_space_client/models/user_model.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;

  UserCubit({required this.userRepository}) : super(UserState.initial());

  /// Fetch user info from server
  Future<void> fetchUserInfo() async {
    try {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final user = await userRepository.fetchUserInfo();
      emit(state.copyWith(
        user: user,
        stateStatus: StateStatus.success,
      ));
    } on AppException catch (e) {
      emit(
        state.copyWith(
          error: e,
          stateStatus: StateStatus.error,
        ),
      );
    }
  }

  /// Get user cached user info
  Future<void> getUserInfo() async {
    final user = await userRepository.getUserInfo();
    emit(state.copyWith(
      user: user,
      stateStatus: StateStatus.success,
      error: null,
    ));
  }
}
