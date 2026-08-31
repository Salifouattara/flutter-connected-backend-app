# Flutter Connected

Application Flutter de démonstration prête pour une soutenance : authentification JWT, API REST, cache local et repli hors-ligne.

## Architecture

- `lib/core` : Dio, interceptor JWT, conversion centralisée des erreurs et persistance Hive.
- `lib/domain` : entités et contrats de repositories, sans dépendance à Flutter/Dio.
- `lib/data` : modèles JSON, sources distante/locale et implémentations des repositories.
- `lib/presentation` : contrôleurs `ChangeNotifier` et trois écrans : authentification, liste, détail.

Le repository des utilisateurs tente l'API, écrit le résultat dans Hive, puis retourne automatiquement le cache en cas d'échec réseau. L'écran affiche alors une bannière « mode hors-ligne ».

## API et JWT

Le projet utilise [DummyJSON](https://dummyjson.com/docs). `POST /auth/login` retourne un `accessToken` JWT. `AuthInterceptor` l'ajoute uniquement aux requêtes signalées comme sécurisées, sous la forme `Authorization: Bearer <token>`.

Identifiants de test : `emilys` / `emilyspass`.

L'inscription appelle `POST /users/add`, une simulation offerte par DummyJSON ; reconnectez-vous ensuite avec le compte de test. Pour un backend/Supabase réel, remplacez `ApiConfig.baseUrl` et les méthodes dans `AuthRemoteDataSource`, sans modifier les écrans ni les repositories.

## Installation

```bash
flutter pub get
# Nécessaire une seule fois si les hôtes Android/iOS ne sont pas encore présents
flutter create --platforms=android,ios .
flutter run
```

## Tests

```bash
flutter test
```

Les tests de repository couvrent le succès distant/cache, le repli cache et l'échec combiné réseau/cache.
