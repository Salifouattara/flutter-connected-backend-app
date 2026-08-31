import 'user.dart';
class Session {
  const Session({required this.token, required this.refreshToken, required this.user});
  final String token;
  final String refreshToken;
  final User user;
}
