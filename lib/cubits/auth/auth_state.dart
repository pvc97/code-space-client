part of 'auth_cubit.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthState extends BaseState {
  final AuthStatus authStatus;

  const AuthState({
    required this.authStatus,
    super.stateStatus,
    super.error,
  });

  factory AuthState.unAuthenticated() {
    return const AuthState(
      authStatus: AuthStatus.unauthenticated,
      stateStatus: StateStatus.initial,
    );
  }

  @override
  List<Object?> get props => [authStatus, ...super.props];

  AuthState copyWith({
    AuthStatus? authStatus,
    StateStatus? stateStatus,
    AppException? error,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      stateStatus: stateStatus ?? this.stateStatus,
      error: error ?? this.error,
    );
  }
}
