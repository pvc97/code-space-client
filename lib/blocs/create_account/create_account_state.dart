part of 'create_account_cubit.dart';

class CreateAccountState extends BaseState {
  final String? userId;

  const CreateAccountState({
    this.userId,
    required super.stateStatus,
    super.error,
  });

  factory CreateAccountState.initial() {
    return const CreateAccountState(
      stateStatus: StateStatus.initial,
      userId: null,
    );
  }

  CreateAccountState copyWith({
    String? userId,
    StateStatus? stateStatus,
    AppException? error,
  }) {
    return CreateAccountState(
      userId: userId ?? this.userId,
      stateStatus: stateStatus ?? this.stateStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [userId, ...super.props];
}
