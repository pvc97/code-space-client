part of 'account_cubit.dart';

class AccountState extends BaseState {
  final List<UserModel> accounts;
  final int page;
  final bool isLoadingMore;
  final bool isLoadMoreDone;
  final String query;
  final StateStatus deleteStatus;

  const AccountState({
    required this.accounts,
    required this.page,
    required this.isLoadingMore,
    required this.isLoadMoreDone,
    required this.query,
    required this.deleteStatus,
    required super.stateStatus,
    super.error,
  });

  factory AccountState.initial() {
    return const AccountState(
      accounts: [],
      page: NetworkConstants.defaultPage,
      stateStatus: StateStatus.initial,
      isLoadingMore: false,
      isLoadMoreDone: false,
      deleteStatus: StateStatus.initial,
      query: NetworkConstants.defaultQuery,
    );
  }

  @override
  List<Object?> get props => [
        accounts,
        page,
        isLoadingMore,
        isLoadMoreDone,
        query,
        deleteStatus,
        stateStatus,
        error
      ];

  AccountState copyWith({
    List<UserModel>? accounts,
    int? page,
    bool? isLoadingMore,
    bool? isLoadMoreDone,
    String? query,
    StateStatus? deleteStatus,
    StateStatus? stateStatus,
    AppException? error,
  }) {
    return AccountState(
      accounts: accounts ?? this.accounts,
      page: page ?? this.page,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isLoadMoreDone: isLoadMoreDone ?? this.isLoadMoreDone,
      query: query ?? this.query,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      stateStatus: stateStatus ?? this.stateStatus,
      error: error ?? this.error,
    );
  }
}
