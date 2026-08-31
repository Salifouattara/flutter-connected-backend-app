import 'package:dio/dio.dart';
import '../storage/app_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage);
  final AppStorage _storage;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Only endpoints explicitly marked protected receive the JWT.
    if (options.extra['authenticated'] == true && _storage.token != null) {
      options.headers['Authorization'] = 'Bearer ${_storage.token}';
    }
    handler.next(options);
  }
}
