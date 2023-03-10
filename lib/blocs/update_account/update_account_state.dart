part of 'update_account_cubit.dart';

class UpdateAccountState extends BaseState {
  // stateStatus from BaseState is used to manage the state of get user info
  final UserModel? user;

  final StateStatus updateStatus;

  const UpdateAccountState({
    this.user,
    required this.updateStatus,
    required super.stateStatus,
    super.error,
  });

  factory UpdateAccountState.initial() {
    return const UpdateAccountState(
      user: null,
      stateStatus: StateStatus.initial,
      updateStatus: StateStatus.initial,
    );
  }

  @override
  List<Object?> get props => [user, stateStatus, updateStatus, error];

  UpdateAccountState copyWith({
    UserModel? user,
    StateStatus? stateStatus,
    StateStatus? updateStatus,
    AppException? error,
  }) {
    return UpdateAccountState(
      user: user ?? this.user,
      updateStatus: updateStatus ?? this.updateStatus,
      stateStatus: stateStatus ?? this.stateStatus,
      error: error ?? this.error,
    );
  }
}
