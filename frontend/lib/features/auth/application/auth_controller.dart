import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../data/auth_exception.dart';
import '../data/auth_repository.dart';
import 'auth_state.dart';

final secureStorageProvider = Provider<SecureStorageService>(
  (ref) => const SecureStorageService(),
);

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final storage = ref.watch(secureStorageProvider);

  return AuthRepository(ApiClient(readToken: storage.readToken));
});

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState.unknown();
  }

  Future<void> restoreSession() async {
    final token = await ref.read(secureStorageProvider).readToken();
    if (token == null || token.isEmpty) {
      state = const AuthState.unauthenticated();
      return;
    }

    try {
      final user = await ref.read(authRepositoryProvider).me();
      state = AuthState.authenticated(token, user: user);
    } on AuthException {
      await ref.read(secureStorageProvider).clearToken();
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final session = await ref
          .read(authRepositoryProvider)
          .login(email: email.trim(), password: password);
      await ref.read(secureStorageProvider).writeToken(session.token);
      state = AuthState.authenticated(session.token, user: session.user);
    } on AuthException catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.message);
      rethrow;
    }
  }

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final session = await ref
          .read(authRepositoryProvider)
          .register(
            username: username.trim(),
            email: email.trim(),
            password: password,
          );
      await ref.read(secureStorageProvider).writeToken(session.token);
      state = AuthState.authenticated(session.token, user: session.user);
    } on AuthException catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.message);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await ref.read(authRepositoryProvider).logout();
    } on AuthException {
      // The local token is cleared even if the server cannot revoke it.
    }

    await ref.read(secureStorageProvider).clearToken();
    state = const AuthState.unauthenticated();
  }
}
