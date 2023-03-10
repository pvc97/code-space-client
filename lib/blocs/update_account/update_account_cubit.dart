import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/data/repositories/user_repository.dart';
import 'package:code_space_client/models/app_exception.dart';
import 'package:code_space_client/models/user_model.dart';

part 'update_account_state.dart';

class UpdateAccountCubit extends Cubit<UpdateAccountState> {
  final UserRepository userRepository;

  UpdateAccountCubit({
    required this.userRepository,
  }) : super(UpdateAccountState.initial());

  Future<void> fetchUserInfo(String userId) async {
    try {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final user = await userRepository.fetchUserInfo(userId: userId);
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
