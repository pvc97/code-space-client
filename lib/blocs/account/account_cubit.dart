import 'package:code_space_client/utils/logger/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/constants/network_constants.dart';
import 'package:code_space_client/data/repositories/user_repository.dart';
import 'package:code_space_client/models/app_exception.dart';
import 'package:code_space_client/models/user_model.dart';

part 'account_state.dart';

// I call this class AccountCubit instead of UserCubit because I already have a UserCubit class
class AccountCubit extends Cubit<AccountState> {
  final UserRepository userRepository;

  AccountCubit({
    required this.userRepository,
  }) : super(AccountState.initial());

  @override
  Future<void> close() {
    logger.d('AccountCubit closed');
    return super.close();
  }

  void getAccounts({
    int? initialPage,
    String? initialQuery,
  }) async {
    int page = initialPage ?? state.page;
    String query = initialQuery ?? state.query;

    if (state.isLoadingMore) {
      // Don't load more if already loading
      return;
    }

    emit(state.copyWith(
      isLoadingMore: true,
      stateStatus: StateStatus.loading,
    ));

    try {
      final accounts = await userRepository.getUsers(
        query: query,
        page: page,
        limit: NetworkConstants.defaultLimit,
      );

      emit(
        state.copyWith(
          accounts: accounts,
          page: page,
          query: query,
          isLoadingMore: false,
          isLoadMoreDone: accounts.length < NetworkConstants.defaultLimit,
          stateStatus: StateStatus.success,
        ),
      );
    } on AppException catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        stateStatus: StateStatus.error,
        error: e,
      ));
    }
  }

  void loadMoreAccounts() async {
    if (state.isLoadingMore || state.isLoadMoreDone) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final accounts = await userRepository.getUsers(
        page: state.page + 1,
        query: state.query,
        limit: NetworkConstants.defaultLimit,
      );

      emit(state.copyWith(
        accounts: [...state.accounts, ...accounts],
        page: state.page + 1,
        isLoadingMore: false,
        isLoadMoreDone: accounts.length < NetworkConstants.defaultLimit,
        stateStatus: StateStatus.success,
      ));
    } on AppException catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        stateStatus: StateStatus.error,
        error: e,
      ));
    }
  }

  void refreshAccounts() {
    getAccounts(
      initialQuery: state.query,
      initialPage: NetworkConstants.defaultPage,
    );
  }

  void searchAccounts({required String query}) async {
    if (query == state.query) return;

    getAccounts(
      initialQuery: query.trim(),
      initialPage: NetworkConstants.defaultPage,
    );
  }
}
