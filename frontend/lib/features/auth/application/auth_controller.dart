import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/secure_storage_service.dart';
import 'auth_state.dart';

final secureStorageProvider = Provider<SecureStorageService>(
  (ref) => const SecureStorageService(),
);

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState.unknown();
  }

  Future<void> restoreSession() async {
    final token = await ref.read(secureStorageProvider).readToken();
    state = token == null || token.isEmpty
        ? const AuthState.unauthenticated()
        : AuthState.authenticated(token);
  }

  Future<void> signInPlaceholder() async {
    const demoToken = 'local-demo-token';
    await ref.read(secureStorageProvider).writeToken(demoToken);
    state = const AuthState.authenticated(demoToken);
  }

  Future<void> signOut() async {
    await ref.read(secureStorageProvider).clearToken();
    state = const AuthState.unauthenticated();
  }
}
