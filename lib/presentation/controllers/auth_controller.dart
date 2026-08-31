import 'package:flutter/foundation.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._repository);
  final AuthRepository _repository;
  bool get isAuthenticated => _repository.isAuthenticated;
  bool loading = false;
  String? error;

  Future<bool> login(String username, String password) =>
      _run(() => _repository.login(username, password));
  Future<bool> register(String firstName, String email, String password) =>
      _run(() => _repository.register(firstName, email, password));

  Future<bool> _run(Future<void> Function() action) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      await action();
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('NetworkException: ', '');
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    notifyListeners();
  }
}
