import 'package:dio/dio.dart';
import 'package:flutter_connected/core/network/network_exception.dart';
import 'package:flutter_connected/data/datasources/user_local_data_source.dart';
import 'package:flutter_connected/data/datasources/user_remote_data_source.dart';
import 'package:flutter_connected/data/models/user_model.dart';
import 'package:flutter_connected/data/repositories/user_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemote extends Mock implements UserRemoteDataSource {}
class MockLocal extends Mock implements UserLocalDataSource {}

DioException connectionError() => DioException(
  requestOptions: RequestOptions(path: '/users'),
  type: DioExceptionType.connectionError,
);

void main() {
  late MockRemote remote;
  late MockLocal local;
  late UserRepositoryImpl repository;
  final users = [const UserModel(id: 1, firstName: 'Ada', lastName: 'Lovelace', email: 'ada@test.dev', image: '')];

  setUp(() { remote = MockRemote(); local = MockLocal(); repository = UserRepositoryImpl(remote, local); });

  test('retourne les données distantes et les met en cache', () async {
    when(() => remote.getUsers()).thenAnswer((_) async => users);
    when(() => local.cacheUsers(users)).thenAnswer((_) async {});
    final result = await repository.getUsers();
    expect(result.data.single.email, 'ada@test.dev');
    expect(result.isFromCache, isFalse);
    verify(() => remote.getUsers()).called(1);
    verify(() => local.cacheUsers(users)).called(1);
    verifyNever(() => local.getCachedUsers());
  });

  test('bascule sur le cache si le réseau échoue', () async {
    when(() => remote.getUsers()).thenThrow(connectionError());
    when(() => local.getCachedUsers()).thenAnswer((_) async => users);
    final result = await repository.getUsers();
    expect(result.isFromCache, isTrue);
    expect(result.data, users);
    verify(() => remote.getUsers()).called(1);
    verify(() => local.getCachedUsers()).called(1);
    verifyNever(() => local.cacheUsers(any()));
  });

  test('renvoie une erreur utilisateur si réseau et cache échouent', () async {
    when(() => remote.getUsers()).thenThrow(connectionError());
    when(() => local.getCachedUsers()).thenThrow(StateError('cache vide'));
    expect(repository.getUsers(), throwsA(isA<NetworkException>()));
    verify(() => remote.getUsers()).called(1);
    verify(() => local.getCachedUsers()).called(1);
  });
}
