import 'package:flutter_connected/core/storage/app_storage.dart';
import 'package:flutter_connected/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_connected/data/models/session_model.dart';
import 'package:flutter_connected/data/models/user_model.dart';
import 'package:flutter_connected/data/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemote extends Mock implements AuthRemoteDataSource {}
class MockStorage extends Mock implements AppStorage {}

void main() {
  late MockAuthRemote remote;
  late MockStorage storage;
  late AuthRepositoryImpl repository;
  const session = SessionModel(
    token: 'access-token', refreshToken: 'refresh-token',
    user: UserModel(id: 7, firstName: 'Ada', lastName: 'Lovelace', email: 'ada@test.dev', image: ''),
  );

  setUp(() { remote = MockAuthRemote(); storage = MockStorage(); repository = AuthRepositoryImpl(remote, storage); });

  test('login persiste les deux tokens et le profil', () async {
    when(() => remote.login('ada', 'secret')).thenAnswer((_) async => session);
    when(() => storage.saveTokens(accessToken: any(named: 'accessToken'), refreshToken: any(named: 'refreshToken'))).thenAnswer((_) async {});
    when(() => storage.saveProfile(any())).thenAnswer((_) async {});

    final result = await repository.login('ada', 'secret');

    expect(result.token, 'access-token');
    verify(() => storage.saveTokens(accessToken: 'access-token', refreshToken: 'refresh-token')).called(1);
    verify(() => storage.saveProfile({'id': 7, 'firstName': 'Ada'})).called(1);
  });

  test('register délègue la création de compte à la source distante', () async {
    when(() => remote.register('Ada', 'ada@test.dev', 'secret')).thenAnswer((_) async {});
    await repository.register('Ada', 'ada@test.dev', 'secret');
    verify(() => remote.register('Ada', 'ada@test.dev', 'secret')).called(1);
  });

  test('logout efface complètement la session locale', () async {
    when(storage.clearSession).thenAnswer((_) async {});
    await repository.logout();
    verify(storage.clearSession).called(1);
  });
}
