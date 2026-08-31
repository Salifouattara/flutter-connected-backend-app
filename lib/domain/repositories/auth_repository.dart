import '../entities/session.dart';
abstract class AuthRepository {
  Future<Session> login(String username, String password);
  Future<void> register(String firstName, String email, String password);
  Future<void> logout();
  bool get isAuthenticated;
}
