import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/endpoints.dart';
import 'auth_exception.dart';
import 'auth_session.dart';
import 'auth_user.dart';

class AuthRepository {
  const AuthRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        Endpoints.login,
        data: {
          'user': {'email': email, 'password': password},
        },
      );

      return AuthSession.fromJson(response.data ?? {});
    } on DioException catch (error) {
      throw _authExceptionFromDio(error);
    }
  }

  Future<AuthSession> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        Endpoints.register,
        data: {
          'user': {
            'username': username,
            'email': email,
            'password': password,
            'password_confirmation': password,
            'language': 'ca',
          },
        },
      );

      return AuthSession.fromJson(response.data ?? {});
    } on DioException catch (error) {
      throw _authExceptionFromDio(error);
    }
  }

  Future<AuthUser> me() async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        Endpoints.me,
      );
      final data = response.data ?? {};
      return AuthUser.fromJson(data['user'] as Map<String, dynamic>);
    } on DioException catch (error) {
      throw _authExceptionFromDio(error);
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.dio.delete<void>(Endpoints.logout);
    } on DioException catch (error) {
      throw _authExceptionFromDio(error);
    }
  }

  AuthException _authExceptionFromDio(DioException error) {
    final data = error.response?.data;

    if (data is Map<String, dynamic>) {
      final errorPayload = data['error'];
      if (errorPayload is Map<String, dynamic>) {
        return AuthException(
          errorPayload['message'] as String? ?? 'Authentication failed',
          details: _detailsFromJson(errorPayload['details']),
        );
      }
    }

    return const AuthException(
      'No s ha pogut connectar amb el servidor. Torna-ho a provar.',
    );
  }

  Map<String, List<String>>? _detailsFromJson(Object? json) {
    if (json is! Map<String, dynamic>) {
      return null;
    }

    return json.map((key, value) {
      final messages = value is List
          ? value.map((item) => item.toString()).toList()
          : [value.toString()];
      return MapEntry(key, messages);
    });
  }
}
