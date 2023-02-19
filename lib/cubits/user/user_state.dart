part of 'user_cubit.dart';

class UserState extends BaseState {
  final UserModel? user;

  const UserState({
    this.user,
    required super.stateStatus,
    super.error,
  });

  factory UserState.initial() {
    return const UserState(
      user: null,
      stateStatus: StateStatus.initial,
    );
  }

  @override
  List<Object?> get props => [user, ...super.props];

  UserState copyWith({
    UserModel? user,
    StateStatus? stateStatus,
    AppException? error,
  }) {
    return UserState(
      user: user ?? this.user,
      stateStatus: stateStatus ?? this.stateStatus,
      error: error ?? this.error,
    );
  }
}
