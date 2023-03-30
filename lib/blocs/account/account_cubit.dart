import 'dart:async';

import 'package:code_space_client/constants/app_constants.dart';
import 'package:code_space_client/utils/debounce.dart';
import 'package:code_space_client/utils/event_bus/app_event.dart';
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
  final _debounce = Debounce(milliseconds: AppConstants.searchDebounceDuration);

  final UserRepository userRepository;

  final _subscriptions = <StreamSubscription>[];

  AccountCubit({
    required this.userRepository,
  }) : super(AccountState.initial()) {
    _registerToEventBus();
  }

  @override
  Future<void> close() {
    logger.d('AccountCubit closed');
    // Cancel all subscriptions
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
    return super.close();
  }

  void _registerToEventBus() {
    _subscriptions.add(
      eventBus.on<CreateAccountSuccessEvent>().listen((event) {
        _onUpdateCreateSuccess(event.user);
      }),
    );
    _subscriptions.add(
      eventBus.on<UpdateAccountSuccessEvent>().listen((event) {
        _onUpdateAccountSuccess(event.user);
      }),
    );
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

  // Because I am using CUBIT, so I have to create my own debounce
  // instead of using a debounce from BLOC
  void searchAccounts({required String query}) async {
    _debounce.run(debouncedAction: () {
      if (query == state.query) return;

      getAccounts(
        initialQuery: query.trim(),
        initialPage: NetworkConstants.defaultPage,
      );
    });
  }

  // TODO: Handle clear search
  // void clearSearch() {
  //   getAccounts(
  //     initialQuery: NetworkConstants.defaultQuery,
  //     initialPage: NetworkConstants.defaultPage,
  //   );
  // }

  void deleteAccount({required String userId}) async {
    emit(state.copyWith(deleteStatus: StateStatus.loading));

    try {
      await userRepository.deleteUser(userId: userId);

      final accounts =
          state.accounts.where((account) => account.userId != userId).toList();

      // After deleting an account, I try to load more
      // Ex: List of accounts: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
      // Current page is page 1: [1, 2, 3, 4, 5]
      // After deleting user 2, the page data will be [1, 3, 4, 5]
      // Now load more with page 2 => result from api: [7, 8, 9, 10, 11]
      // Where is 6? :v
      // Because now 6 is in page 1 (each page has 5 accounts)
      // I get page 1 again and check if the last account is NOT the same
      // as the last account in the old list account of page 1 then add it to the old list

      // Get list account of current page
      final accountsOfCurrentPage = await userRepository.getUsers(
        page: state.page,
        query: state.query,
        limit: NetworkConstants.defaultLimit,
      );

      // If the last account of current page (page with new data) is NOT the same
      // as the last account in the old list account then add it to the old list
      if (accountsOfCurrentPage.isNotEmpty && accounts.isNotEmpty) {
        final lastAccount = accountsOfCurrentPage.last;
        if (accounts.last.userId != lastAccount.userId) {
          accounts.add(lastAccount);
        }
      }

      emit(state.copyWith(
        deleteStatus: StateStatus.success,
        accounts: accounts,
      ));
    } on AppException catch (e) {
      emit(state.copyWith(
        deleteStatus: StateStatus.error,
        error: e,
      ));
    }
  }

  void _onUpdateAccountSuccess(UserModel newUser) {
    final accounts = state.accounts.map((account) {
      if (account.userId == newUser.userId) {
        return newUser;
      }
      return account;
    }).toList();

    emit(state.copyWith(accounts: accounts));
  }

  void _onUpdateCreateSuccess(UserModel newUser) {
    final accounts = state.accounts;
    accounts.insert(0, newUser);

    emit(state.copyWith(accounts: accounts));
  }
}
