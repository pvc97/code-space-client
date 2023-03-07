import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/data/repositories/user_repository.dart';
import 'package:code_space_client/models/app_exception.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final UserRepository userRepository;

  ChangePasswordCubit({
    required this.userRepository,
  }) : super(ChangePasswordState.initial());

  void changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(state.copyWith(stateStatus: StateStatus.loading));
    try {
      await userRepository.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      emit(state.copyWith(stateStatus: StateStatus.success));
    } catch (e) {
      emit(state.copyWith(
        stateStatus: StateStatus.error,
        error: e as AppException,
      ));
    }
  }
}
