import 'package:code_space_client/utils/logger/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/data/repositories/user_repository.dart';
import 'package:code_space_client/models/app_exception.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final UserRepository userRepository;

  ResetPasswordCubit({
    required this.userRepository,
  }) : super(ResetPasswordState.initial());

  @override
  Future<void> close() {
    logger.d('ResetPasswordCubit closed');
    return super.close();
  }

  void resetPassword(
      {required String userId, required String newPassword}) async {
    emit(state.copyWith(stateStatus: StateStatus.loading));
    try {
      await userRepository.resetPassword(
        userId: userId,
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
