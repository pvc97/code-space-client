part of 'change_password_cubit.dart';

class ChangePasswordState extends BaseState {
  const ChangePasswordState({
    required super.stateStatus,
    super.error,
  });

  factory ChangePasswordState.initial() {
    return const ChangePasswordState(
      stateStatus: StateStatus.initial,
      error: null,
    );
  }

  ChangePasswordState copyWith({
    StateStatus? stateStatus,
    AppException? error,
  }) {
    return ChangePasswordState(
      stateStatus: stateStatus ?? this.stateStatus,
      error: error ?? this.error,
    );
  }
}
