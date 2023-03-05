part of 'account_cubit.dart';

class AccountState extends BaseState {
  final List<UserModel> accounts;
  final int page;
  final bool isLoadingMore;
  final bool isLoadMoreDone;

  const AccountState({
    required this.accounts,
    required this.page,
    required this.isLoadingMore,
    required this.isLoadMoreDone,
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
    );
  }

  @override
  List<Object?> get props =>
      [accounts, page, isLoadingMore, isLoadMoreDone, ...super.props];

  AccountState copyWith({
    List<UserModel>? accounts,
    int? page,
    bool? isLoadingMore,
    bool? isLoadMoreDone,
    StateStatus? stateStatus,
    AppException? error,
  }) {
    return AccountState(
      accounts: accounts ?? this.accounts,
      page: page ?? this.page,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isLoadMoreDone: isLoadMoreDone ?? this.isLoadMoreDone,
      stateStatus: stateStatus ?? this.stateStatus,
      error: error ?? this.error,
    );
  }
}
