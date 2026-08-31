import 'package:dio/dio.dart';
import '../models/session_model.dart';
class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);
  final Dio _dio;
  Future<SessionModel> login(String username, String password) async {
    final response = await _dio.post('/auth/login', data: {'username': username, 'password': password, 'expiresInMins': 60});
    return SessionModel.fromJson(response.data as Map<String, dynamic>);
  }
  Future<void> register(String firstName, String email, String password) async {
    await _dio.post('/users/add', data: {'firstName': firstName, 'email': email, 'password': password});
  }
}
