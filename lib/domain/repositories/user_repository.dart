import '../entities/user.dart';
class CachedData<T> {
  const CachedData(this.data, {this.isFromCache = false});
  final T data;
  final bool isFromCache;
}
abstract class UserRepository {
  Future<CachedData<List<User>>> getUsers();
  Future<User> getUser(int id);
}
