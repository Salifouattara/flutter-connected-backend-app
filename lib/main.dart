import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'core/di/app_dependencies.dart';
import 'presentation/controllers/auth_controller.dart';
import 'presentation/controllers/users_controller.dart';
import 'presentation/screens/auth_screen.dart';
import 'presentation/screens/dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(App(dependencies: await AppDependencies.create()));
}
class App extends StatelessWidget {
  const App({super.key, required this.dependencies});
  final AppDependencies dependencies;
  @override Widget build(BuildContext context) {
    final auth = dependencies.authRepository;
    return MultiProvider(providers: [ChangeNotifierProvider(create: (_) => AuthController(auth)), ChangeNotifierProvider(create: (_) => UsersController(dependencies.userRepository))], child: MaterialApp(debugShowCheckedModeBanner: false, theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true), home: auth.isAuthenticated ? const DashboardScreen() : const AuthScreen()));
  }
}
