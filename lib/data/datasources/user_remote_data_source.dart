import 'package:dio/dio.dart';
import '../models/user_model.dart';
class UserRemoteDataSource {
  UserRemoteDataSource(this._dio);
  final Dio _dio;
  Future<List<UserModel>> getUsers() async {
    final response = await _dio.get('/users', options: Options(extra: {'authenticated': true}));
    final users = (response.data as Map<String, dynamic>)['users'] as List;
    return users.map((e) => UserModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }
  Future<UserModel> getUser(int id) async {
    final response = await _dio.get('/users/$id', options: Options(extra: {'authenticated': true}));
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }
}
