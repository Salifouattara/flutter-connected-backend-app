import '../../core/storage/app_storage.dart';
import '../../core/network/network_exception.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';
import 'package:dio/dio.dart';
import '../datasources/auth_remote_data_source.dart';
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote, this._storage);
  final AuthRemoteDataSource _remote;
  final AppStorage _storage;
  @override bool get isAuthenticated => _storage.token != null;
  @override Future<Session> login(String username, String password) async {
    try { final session = await _remote.login(username, password); await _storage.saveToken(session.token); await _storage.saveProfile({'id': session.user.id, 'firstName': session.user.firstName}); return session; }
    on DioException catch (e) { throw NetworkException.fromDio(e); }
  }
  @override Future<void> register(String firstName, String email, String password) async { try { await _remote.register(firstName, email, password); } on DioException catch (e) { throw NetworkException.fromDio(e); } }
  @override Future<void> logout() => _storage.clearSession();
}
