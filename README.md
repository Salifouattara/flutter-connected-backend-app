# Flutter Connected

[![Flutter quality gate](https://github.com/OWNER/flutter_connected/actions/workflows/flutter_test.yml/badge.svg)](https://github.com/OWNER/flutter_connected/actions/workflows/flutter_test.yml)

Application Flutter pensée pour un contexte de certification : authentification JWT, API REST réelle, cache local persistant, repli hors-ligne et tests automatisés.

## Architecture Clean

Le projet isole les responsabilités pour que l'interface reste indépendante de la source des données :

- `lib/core` contient Dio, l'intercepteur JWT/refresh token, Hive, le point de composition `AppDependencies` et les exceptions applicatives typées (`NetworkException`, `ServerException`, `CacheException`).
- `lib/domain` définit les entités métier et les contrats de repositories, sans dépendre de Flutter ou Dio.
- `lib/data` regroupe les DTO/modèles, les sources distantes/locales et les implémentations des repositories.
- `lib/presentation` contient les contrôleurs `ChangeNotifier` et les écrans Login/Register, tableau de bord et profil.

`UserRepositoryImpl` charge l'API puis écrit dans Hive. Lorsqu'une requête réseau échoue, il retourne le dernier cache disponible et le tableau de bord signale explicitement le mode hors-ligne. Les erreurs transport, serveur et cache sont converties en exceptions typées, puis en messages adaptés à l'utilisateur, sans comparaison de chaînes dans les contrôleurs.

## API, JWT et refresh token

L'implémentation utilise [DummyJSON](https://dummyjson.com/docs) : `POST /auth/login`, `POST /auth/refresh`, `POST /users/add` et `GET /users`. Utilisez `emilys` / `emilyspass` pour la démonstration. Après le login, `accessToken` et `refreshToken` sont stockés dans Hive. `AuthInterceptor` ajoute `Authorization: Bearer <token>` aux routes sécurisées. Face à une réponse 401, il renouvelle une seule fois le jeton, sauvegarde les nouveaux jetons et rejoue la requête ; si cela échoue, il efface la session.

## Écrans API

L'application comporte trois parcours visibles : l'écran d'authentification, le tableau de bord alimenté par `GET /users` avec pull-to-refresh et bannière hors-ligne, puis le profil. Le profil recharge explicitement `GET /users/{id}` via le repository avant d'afficher les coordonnées de l'utilisateur.

## Démarrage

```bash
flutter pub get
# Une seule fois si les hôtes Android/iOS sont absents
flutter create --platforms=android,ios .
flutter run
```

## Qualité et CI

Les trois suites dans `test/` couvrent le repository utilisateur (API/cache/hors-ligne), le repository d'authentification (login/register/logout) et le mapping des erreurs réseau. GitHub Actions exécute `flutter analyze` et `flutter test` à chaque push et pull request via `.github/workflows/flutter_test.yml`.
