part of 'auth_cubit.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthState extends Equatable {
  final AuthStatus authStatus;

  const AuthState({
    required this.authStatus,
  });

  factory AuthState.authenticated() {
    return const AuthState(authStatus: AuthStatus.unauthenticated);
  }

  @override
  List<Object> get props => [authStatus];

  AuthState copyWith({
    AuthStatus? authStatus,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
    );
  }
}
