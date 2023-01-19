part of 'user_cubit.dart';

class UserState extends BaseState {
  final UserModel? user;

  const UserState({
    this.user,
    required super.status,
  });

  factory UserState.initial() {
    return const UserState(status: BaseStatus.initial);
  }

  @override
  List<Object?> get props => [user, ...super.props];
}
