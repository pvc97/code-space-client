import 'package:code_space_client/blocs/auth/auth_cubit.dart';
import 'package:code_space_client/data/local/local_storage_manager.dart';
import 'package:code_space_client/data/local/local_storage_manager_impl.dart';
import 'package:code_space_client/network/api_provider.dart';
import 'package:code_space_client/network/intercepters/auth_intercepter.dart';
import 'package:code_space_client/repositories/auth_repository.dart';
import 'package:code_space_client/services/auth_service.dart';
import 'package:code_space_client/services/user_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
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
      () {
        final dio = Dio();

        final apiProvider = ApiProvider(
          dio: dio,
          localStorage: sl(),
        );

        if (kDebugMode) {
          dio.interceptors.add(
            PrettyDioLogger(
              requestHeader: true,
              requestBody: true,
              responseBody: true,
              responseHeader: false,
              compact: true,
            ),
          );
        }

        dio.interceptors.add(
          AuthIntercepter(
            localStorage: sl(),
            apiProvider: apiProvider,
          ),
        );

        return apiProvider;
      },
    );

    sl.registerLazySingleton<AuthService>(
      () => AuthService(
        apiProvider: sl(),
        localStorage: sl(),
      ),
    );

    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepository(authService: sl()),
    );

    sl.registerLazySingleton<AuthCubit>(
      () => AuthCubit(
        authRepository: sl(),
        localStorage: sl(),
      ),
    );

    sl.registerLazySingleton<UserService>(() => UserService(apiProvider: sl()));
  }
}
