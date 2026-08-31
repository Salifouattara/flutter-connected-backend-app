import '../../domain/entities/session.dart';
import 'user_model.dart';
class SessionModel extends Session {
  const SessionModel({required super.token, required super.user});
  factory SessionModel.fromJson(Map<String, dynamic> json) => SessionModel(
    token: (json['accessToken'] ?? json['token']) as String,
    user: UserModel.fromJson(json),
  );
}
