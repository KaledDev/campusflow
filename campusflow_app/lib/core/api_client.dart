// lib/core/api_client.dart
import 'package:dio/dio.dart';

import 'auth_storage.dart';

class ApiClient {
  ApiClient({
    required AuthStorage authStorage,
    required void Function() onUnauthorized,
    String baseUrl = defaultBaseUrl,
  }) : _authStorage = authStorage,
       _onUnauthorized = onUnauthorized {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _authStorage.readToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await _authStorage.clearToken();
            _onUnauthorized();
          }
          handler.next(error);
        },
      ),
    );
  }

  // 10.0.2.2 correspond à la machine hôte depuis l'émulateur Android
  static const String defaultBaseUrl = 'http://10.0.2.2:3000';

  final AuthStorage _authStorage;
  final void Function() _onUnauthorized;
  late final Dio dio;
}
