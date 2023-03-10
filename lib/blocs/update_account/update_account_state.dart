part of 'update_account_cubit.dart';

class UpdateAccountState extends BaseState {
  // stateStatus from BaseState is used to manage the state of get user info
  final UserModel? user;

  const UpdateAccountState({
    this.user,
    required super.stateStatus,
    super.error,
  });

  factory UpdateAccountState.initial() {
    return const UpdateAccountState(
      user: null,
      stateStatus: StateStatus.initial,
    );
  }

  @override
  List<Object?> get props => [user, stateStatus, error];

  UpdateAccountState copyWith({
    UserModel? user,
    StateStatus? stateStatus,
    AppException? error,
  }) {
    return UpdateAccountState(
      user: user ?? this.user,
      stateStatus: stateStatus ?? this.stateStatus,
      error: error ?? this.error,
    );
  }
}
