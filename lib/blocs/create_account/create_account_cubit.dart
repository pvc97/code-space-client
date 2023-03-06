import 'package:code_space_client/utils/logger/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/data/repositories/user_repository.dart';
import 'package:code_space_client/models/app_exception.dart';

part 'create_account_state.dart';

class CreateAccountCubit extends Cubit<CreateAccountState> {
  final UserRepository userRepository;

  CreateAccountCubit({
    required this.userRepository,
  }) : super(CreateAccountState.initial());

  @override
  Future<void> close() {
    logger.d('CreateAccountCubit closed');
    return super.close();
  }

  void createAccount({
    required String username,
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      emit(state.copyWith(stateStatus: StateStatus.loading));

      final userId = await userRepository.createUser(
        username: username,
        fullName: fullName,
        email: email,
        password: password,
        role: role,
      );

      emit(state.copyWith(
        stateStatus: StateStatus.success,
        userId: userId,
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
