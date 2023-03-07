import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/data/repositories/user_repository.dart';
import 'package:code_space_client/models/app_exception.dart';
import 'package:code_space_client/models/user_model.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;

  UserCubit({required this.userRepository}) : super(UserState.initial());

  /// Fetch specific user info from server
  Future<void> fetchUserInfo(String problemId) async {
    try {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final user = await userRepository.fetchUserInfo(problemId);
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

  /// Get me: cached user info
  Future<void> getMe() async {
    emit(state.copyWith(stateStatus: StateStatus.loading));
    final user = await userRepository.getMe();
    emit(state.copyWith(
      user: user,
      stateStatus: StateStatus.success,
      error: null,
    ));
  }

  Future<void> updateProfile({
    required String userId,
    required String fullName,
    required String email,
  }) async {
    try {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final user = await userRepository.updateProfile(
        userId: userId,
        fullName: fullName,
        email: email,
      );
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
}
