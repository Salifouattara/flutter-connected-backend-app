import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

class UsersController extends ChangeNotifier {
  UsersController(this._repository);
  final UserRepository _repository;
  List<User> users = [];
  bool loading = false;
  bool offline = false;
  String? error;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final result = await _repository.getUsers();
      users = result.data;
      offline = result.isFromCache;
    } catch (e) {
      error = e.toString().replaceFirst('NetworkException: ', '');
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
