part of 'user_cubit.dart';

class UserState extends BaseState {
  final UserModel? user;
  final StateStatus updateProfileState;

  const UserState({
    this.user,
    required this.updateProfileState,
    required super.stateStatus,
    super.error,
  });

  factory UserState.initial() {
    return const UserState(
      user: null,
      updateProfileState: StateStatus.initial,
      stateStatus: StateStatus.initial,
    );
  }

  @override
  List<Object?> get props => [user, updateProfileState, stateStatus, error];

  UserState copyWith({
    UserModel? user,
    StateStatus? stateStatus,
    StateStatus? updateProfileState,
    AppException? error,
  }) {
    return UserState(
      user: user ?? this.user,
      updateProfileState: updateProfileState ?? this.updateProfileState,
      stateStatus: stateStatus ?? this.stateStatus,
      error: error ?? this.error,
    );
  }
}
