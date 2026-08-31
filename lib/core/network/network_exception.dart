import 'package:dio/dio.dart';

/// Base exception exposed to presentation. Its message is safe for the user.
abstract class AppException implements Exception {
  const AppException(this.message);
  final String message;
  @override
  String toString() => message;
}

class ServerException extends AppException {
  const ServerException(super.message, {this.statusCode});
  final int? statusCode;
}

class CacheException extends AppException {
  const CacheException(super.message);
}

/// Authentication refresh failures, so network code never exposes StateError.
class RefreshTokenException extends AppException {
  const RefreshTokenException(super.message);
}

/// Connectivity and timeout failures, distinct from server responses.
class NetworkException extends AppException {
  const NetworkException(super.message);

  static AppException fromDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const NetworkException('La requête a expiré. Réessayez dans un instant.');
      case DioExceptionType.connectionError:
        return const NetworkException('Aucune connexion Internet détectée.');
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode;
        if (code == 401 || code == 403) {
          return ServerException('Votre session a expiré. Veuillez vous reconnecter.', statusCode: code);
        }
        if (code != null && code >= 500) {
          return ServerException('Le service est indisponible. Réessayez plus tard.', statusCode: code);
        }
        return ServerException('La demande est invalide ou refusée.', statusCode: code);
      case DioExceptionType.cancel:
        return const NetworkException('La requête a été annulée.');
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return const NetworkException('Impossible de joindre le serveur. Vérifiez votre connexion.');
    }
  }
}
