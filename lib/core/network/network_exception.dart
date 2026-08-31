import 'package:dio/dio.dart';

/// Message safe to display to end users; technical details stay out of the UI.
class NetworkException implements Exception {
  const NetworkException(this.message);
  final String message;

  factory NetworkException.fromDio(DioException error) {
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
          return const NetworkException('Votre session a expiré. Veuillez vous reconnecter.');
        }
        if (code != null && code >= 500) {
          return const NetworkException('Le service est indisponible. Réessayez plus tard.');
        }
        return const NetworkException('La demande est invalide ou refusée.');
      case DioExceptionType.cancel:
        return const NetworkException('La requête a été annulée.');
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return const NetworkException('Impossible de joindre le serveur. Vérifiez votre connexion.');
    }
  }
}
