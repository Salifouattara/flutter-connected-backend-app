import 'package:flutter/foundation.dart';
import '../../core/network/network_exception.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

class UsersController extends ChangeNotifier {
  UsersController(this._repository);
  final UserRepository _repository;
  List<User> users = [];
  bool loading = false;
  bool offline = false;
  bool empty = false;
  String? error;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final result = await _repository.getUsers();
      users = result.data;
      offline = result.isFromCache;
      empty = users.isEmpty;
    } on AppException catch (e) {
      error = e.message;
      empty = false;
    } catch (_) {
      error = 'Une erreur inattendue est survenue.';
      empty = false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
