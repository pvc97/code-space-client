part of 'create_account_cubit.dart';

class CreateAccountState extends BaseState {
  const CreateAccountState({
    required super.stateStatus,
    super.error,
  });

  factory CreateAccountState.initial() {
    return const CreateAccountState(
      stateStatus: StateStatus.initial,
    );
  }

  CreateAccountState copyWith({
    String? userId,
    StateStatus? stateStatus,
    AppException? error,
  }) {
    return CreateAccountState(
      stateStatus: stateStatus ?? this.stateStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [stateStatus, error];
}
