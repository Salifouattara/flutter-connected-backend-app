import '../../core/storage/app_storage.dart';
import '../models/user_model.dart';
class UserLocalDataSource {
  UserLocalDataSource(this._storage);
  final AppStorage _storage;
  Future<void> cacheUsers(List<UserModel> users) => _storage.saveUsers(users.map((u) => u.toJson()).toList());
  Future<List<UserModel>> getCachedUsers() async {
    final data = _storage.users;
    if (data == null || data.isEmpty) throw StateError('Cache vide');
    return data.map(UserModel.fromJson).toList();
  }
}
