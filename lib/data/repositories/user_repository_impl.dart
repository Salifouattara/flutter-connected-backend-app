import 'package:dio/dio.dart';
import '../../core/network/network_exception.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_data_source.dart';
import '../datasources/user_remote_data_source.dart';
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._remote, this._local);
  final UserRemoteDataSource _remote;
  final UserLocalDataSource _local;
  @override Future<CachedData<List<User>>> getUsers() async {
    try { final users = await _remote.getUsers(); await _local.cacheUsers(users); return CachedData(users); }
    on DioException catch (e) { return _fromCacheOrThrow(e); }
  }
  Future<CachedData<List<User>>> _fromCacheOrThrow(DioException error) async {
    try { return CachedData(await _local.getCachedUsers(), isFromCache: true); }
    catch (_) { throw NetworkException.fromDio(error); }
  }
  @override Future<User> getUser(int id) async { try { return await _remote.getUser(id); } on DioException catch (e) { throw NetworkException.fromDio(e); } }
}
