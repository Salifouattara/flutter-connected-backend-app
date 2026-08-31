import 'package:dio/dio.dart';
import 'api_config.dart';
import 'network_exception.dart';
import 'protected_api_routes.dart';
import '../storage/app_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage, this._dio);
  final AppStorage _storage;
  final Dio _dio;
  Future<void>? _refreshing;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Only endpoints explicitly marked protected receive the JWT.
    final accessToken = _storage.token;
    final requiresAuthentication = options.extra['authenticated'] == true ||
        ProtectedApiRoutes.requiresAuthentication(options.path);
    if (requiresAuthentication && accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final isUnauthorized = err.response?.statusCode == 401;
    final refreshToken = _storage.refreshToken;
    final requiresAuthentication = options.extra['authenticated'] == true ||
        ProtectedApiRoutes.requiresAuthentication(options.path);
    final canRetry = requiresAuthentication &&
        options.extra['retriedAfterRefresh'] != true &&
        options.path != '/auth/refresh' &&
        refreshToken != null &&
        refreshToken.isNotEmpty;

    if (!isUnauthorized || !canRetry) return handler.next(err);

    try {
      final refreshOperation = _refreshing ??= _refreshAccessToken();
      try {
        await refreshOperation;
      } finally {
        if (identical(_refreshing, refreshOperation)) _refreshing = null;
      }
      options.headers['Authorization'] = 'Bearer ${_storage.token}';
      options.extra['retriedAfterRefresh'] = true;
      final response = await _dio.fetch<dynamic>(options);
      handler.resolve(response);
    } catch (_) {
      await _storage.clearSession();
      handler.next(err);
    }
  }

  Future<void> _refreshAccessToken() async {
    final refreshToken = _storage.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      throw const RefreshTokenException('Session expirée : jeton de renouvellement absent.');
    }
    final response = await _dio.post<Map<String, dynamic>>('/auth/refresh', data: {
      'refreshToken': refreshToken,
      'expiresInMins': ApiConfig.refreshTokenLifetimeMinutes,
    });
    final data = response.data;
    final accessToken = data?['accessToken'] as String?;
    if (accessToken == null || accessToken.isEmpty) {
      throw const RefreshTokenException('Session expirée : réponse de renouvellement invalide.');
    }
    await _storage.saveTokens(accessToken: accessToken, refreshToken: data?['refreshToken'] as String?);
  }
}
