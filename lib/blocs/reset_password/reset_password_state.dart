part of 'reset_password_cubit.dart';

class ResetPasswordState extends BaseState {
  const ResetPasswordState({
    required super.stateStatus,
    super.error,
  });

  factory ResetPasswordState.initial() {
    return const ResetPasswordState(
      stateStatus: StateStatus.initial,
      error: null,
    );
  }

  ResetPasswordState copyWith({
    StateStatus? stateStatus,
    AppException? error,
  }) {
    return ResetPasswordState(
      stateStatus: stateStatus ?? this.stateStatus,
      error: error ?? this.error,
    );
  }
}
