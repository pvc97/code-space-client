import 'package:code_space_client/blocs/auth/auth_cubit.dart';
import 'package:code_space_client/data/local/local_storage_manager.dart';
import 'package:code_space_client/data/local/local_storage_manager_impl.dart';
import 'package:code_space_client/network/api_provider.dart';
import 'package:code_space_client/repositories/auth_repository.dart';
import 'package:code_space_client/services/auth_service.dart';
import 'package:code_space_client/services/user_service.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

abstract class Di {
  Di._();

  static Future<void> init() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton<LocalStorageManager>(
      () => LocalStorageManagerImpl(sharedPreferences: sharedPreferences),
    );

    sl.registerLazySingleton<ApiProvider>(
      () => ApiProvider(
        dio: Dio(),
        localStorageManager: sl(),
      ),
    );

    sl.registerLazySingleton<AuthService>(() => AuthService(sl(), sl()));

    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepository(authService: sl()),
    );

    sl.registerLazySingleton<AuthCubit>(() => AuthCubit(sl(), sl()));

    sl.registerLazySingleton<UserService>(() => UserService(sl()));
  }
}
