import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/datasources/user_local_data_source.dart';
import '../../data/datasources/user_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../network/dio_service.dart';
import '../storage/app_storage.dart';

/// Composition root: the only place where concrete infrastructure is wired.
class AppDependencies {
  const AppDependencies({
    required this.authRepository,
    required this.userRepository,
  });

  final AuthRepository authRepository;
  final UserRepository userRepository;

  static Future<AppDependencies> create() async {
    final box = await Hive.openBox<Object?>('app_cache');
    final storage = AppStorage(box);
    final Dio dio = DioService.create(storage);

    return AppDependencies(
      authRepository: AuthRepositoryImpl(AuthRemoteDataSource(dio), storage),
      userRepository: UserRepositoryImpl(
        UserRemoteDataSource(dio),
        UserLocalDataSource(storage),
      ),
    );
  }
}
