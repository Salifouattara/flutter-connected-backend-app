import 'package:flutter/foundation.dart';
import '../../core/network/network_exception.dart';
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
    } on AppException catch (e) {
      error = e.message;
      return false;
    } catch (_) {
      error = 'Une erreur inattendue est survenue.';
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// Keeps loading/error state consistent with login and registration.
  Future<bool> logout() => _run(() => _repository.logout());
}
