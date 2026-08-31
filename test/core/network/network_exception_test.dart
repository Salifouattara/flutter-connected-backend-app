import 'package:dio/dio.dart';
import 'package:flutter_connected/core/network/network_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final options = RequestOptions(path: '/users');

  test('mappe une absence de connexion vers NetworkException', () {
    final error = DioException(requestOptions: options, type: DioExceptionType.connectionError);
    final exception = NetworkException.fromDio(error);
    expect(exception, isA<NetworkException>());
    expect(exception.message, contains('connexion Internet'));
  });

  test('mappe une réponse 500 vers ServerException', () {
    final error = DioException(requestOptions: options, type: DioExceptionType.badResponse, response: Response(requestOptions: options, statusCode: 500));
    final exception = NetworkException.fromDio(error);
    expect(exception, isA<ServerException>());
    expect((exception as ServerException).statusCode, 500);
  });

  test('mappe un délai dépassé vers un message utilisateur clair', () {
    final error = DioException(requestOptions: options, type: DioExceptionType.receiveTimeout);
    expect(NetworkException.fromDio(error).message, contains('expiré'));
  });
}
