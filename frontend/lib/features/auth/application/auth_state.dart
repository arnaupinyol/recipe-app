enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  const AuthState({
    required this.status,
    this.token,
  });

  const AuthState.unknown() : this(status: AuthStatus.unknown);
  const AuthState.authenticated(String token)
      : this(status: AuthStatus.authenticated, token: token);
  const AuthState.unauthenticated()
      : this(status: AuthStatus.unauthenticated);

  final AuthStatus status;
  final String? token;
}
