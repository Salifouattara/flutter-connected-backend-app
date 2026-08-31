import 'package:hive_flutter/hive_flutter.dart';

/// Single local persistence boundary. Maps avoid generated Hive adapters here.
class AppStorage {
  AppStorage(this._box);
  final Box<dynamic> _box;

  static const _tokenKey = 'auth_token';
  static const _profileKey = 'profile';
  static const _usersKey = 'cached_users';

  String? get token => _box.get(_tokenKey) as String?;
  Future<void> saveToken(String token) => _box.put(_tokenKey, token);
  Future<void> clearSession() async {
    await _box.delete(_tokenKey);
    await _box.delete(_profileKey);
  }

  Map<String, dynamic>? get profile {
    final raw = _box.get(_profileKey);
    return raw is Map ? Map<String, dynamic>.from(raw) : null;
  }
  Future<void> saveProfile(Map<String, dynamic> value) => _box.put(_profileKey, value);

  List<Map<String, dynamic>>? get users {
    final raw = _box.get(_usersKey);
    if (raw is! List) return null;
    return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }
  Future<void> saveUsers(List<Map<String, dynamic>> values) => _box.put(_usersKey, values);
}
