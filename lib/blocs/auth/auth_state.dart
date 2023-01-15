part of 'auth_cubit.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
}

class AuthState extends Equatable {
  final AuthStatus authStatus;
  final UserModel? user;

  const AuthState({
    required this.authStatus,
    this.user,
  });

  factory AuthState.authenticated() {
    return const AuthState(authStatus: AuthStatus.unauthenticated);
  }

  @override
  List<Object?> get props => [authStatus, user];

  AuthState copyWith({
    AuthStatus? authStatus,
    UserModel? user,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      user: user ?? this.user,
    );
  }
}
