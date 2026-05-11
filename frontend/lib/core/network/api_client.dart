import 'package:dio/dio.dart';

import '../config/env.dart';
import 'auth_interceptor.dart';

class ApiClient {
  ApiClient({required Future<String?> Function() readToken})
      : dio = Dio(
          BaseOptions(
            baseUrl: Env.apiBaseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        )..interceptors.add(AuthInterceptor(readToken));

  final Dio dio;
}
