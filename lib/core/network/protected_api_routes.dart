/// Declarative list of backend resources that always need a bearer token.
class ProtectedApiRoutes {
  const ProtectedApiRoutes._();

  static bool requiresAuthentication(String path) =>
      path == '/users' || path.startsWith('/users/');
}
