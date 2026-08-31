import 'package:dio/dio.dart';
import '../storage/app_storage.dart';
import 'api_config.dart';
import 'auth_interceptor.dart';

class DioService {
  static Dio create(AppStorage storage) => Dio(BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        headers: const {'Content-Type': 'application/json'},
      ))..interceptors.add(AuthInterceptor(storage));
}
