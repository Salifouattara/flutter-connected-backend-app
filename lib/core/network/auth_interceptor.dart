import 'package:dio/dio.dart';
import '../storage/app_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage, this._dio);
  final AppStorage _storage;
  final Dio _dio;
  Future<void>? _refreshing;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Only endpoints explicitly marked protected receive the JWT.
    if (options.extra['authenticated'] == true && _storage.token != null) {
      options.headers['Authorization'] = 'Bearer ${_storage.token}';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final isUnauthorized = err.response?.statusCode == 401;
    final canRetry = options.extra['authenticated'] == true &&
        options.extra['retriedAfterRefresh'] != true &&
        options.path != '/auth/refresh' &&
        _storage.refreshToken != null;

    if (!isUnauthorized || !canRetry) return handler.next(err);

    try {
      await (_refreshing ??= _refreshAccessToken());
      _refreshing = null;
      options.headers['Authorization'] = 'Bearer ${_storage.token}';
      options.extra['retriedAfterRefresh'] = true;
      final response = await _dio.fetch<dynamic>(options);
      handler.resolve(response);
    } catch (_) {
      _refreshing = null;
      await _storage.clearSession();
      handler.next(err);
    }
  }

  Future<void> _refreshAccessToken() async {
    final response = await _dio.post<Map<String, dynamic>>('/auth/refresh', data: {
      'refreshToken': _storage.refreshToken,
      'expiresInMins': 60,
    });
    final data = response.data;
    final accessToken = data?['accessToken'] as String?;
    if (accessToken == null || accessToken.isEmpty) throw StateError('Refresh token invalide');
    await _storage.saveTokens(accessToken: accessToken, refreshToken: data?['refreshToken'] as String?);
  }
}
