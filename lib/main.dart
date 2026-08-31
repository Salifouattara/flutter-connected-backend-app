import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'core/network/dio_service.dart';
import 'core/storage/app_storage.dart';
import 'data/datasources/auth_remote_data_source.dart';
import 'data/datasources/user_local_data_source.dart';
import 'data/datasources/user_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'presentation/controllers/auth_controller.dart';
import 'presentation/controllers/users_controller.dart';
import 'presentation/screens/auth_screen.dart';
import 'presentation/screens/dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final storage = AppStorage(await Hive.openBox<dynamic>('app_cache'));
  runApp(App(storage: storage, dio: DioService.create(storage)));
}
class App extends StatelessWidget {
  const App({super.key, required this.storage, required this.dio});
  final AppStorage storage;
  final Dio dio;
  @override Widget build(BuildContext context) {
    final auth = AuthRepositoryImpl(AuthRemoteDataSource(dio), storage);
    final users = UserRepositoryImpl(UserRemoteDataSource(dio), UserLocalDataSource(storage));
    return MultiProvider(providers: [ChangeNotifierProvider(create: (_) => AuthController(auth)), ChangeNotifierProvider(create: (_) => UsersController(users))], child: MaterialApp(debugShowCheckedModeBanner: false, theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true), home: auth.isAuthenticated ? const DashboardScreen() : const AuthScreen()));
  }
}
