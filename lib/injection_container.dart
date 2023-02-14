import 'package:code_space_client/cubits/auth/auth_cubit.dart';
import 'package:code_space_client/cubits/locale/locale_cubit.dart';
import 'package:code_space_client/cubits/problem/problem_cubit.dart';
import 'package:code_space_client/cubits/problem_result/problem_result_cubit.dart';
import 'package:code_space_client/cubits/user/user_cubit.dart';
import 'package:code_space_client/data/data_provider/local/local_storage_manager.dart';
import 'package:code_space_client/data/data_provider/local/local_storage_manager_impl.dart';
import 'package:code_space_client/data/data_provider/network/api_provider.dart';
import 'package:code_space_client/data/data_provider/network/intercepters/auth_intercepter.dart';
import 'package:code_space_client/data/data_provider/services/locale_service.dart';
import 'package:code_space_client/data/data_provider/services/problem_service.dart';
import 'package:code_space_client/data/data_provider/services/submission_service.dart';
import 'package:code_space_client/data/repositories/auth_repository.dart';
import 'package:code_space_client/data/data_provider/services/auth_service.dart';
import 'package:code_space_client/data/data_provider/services/user_service.dart';
import 'package:code_space_client/data/repositories/problem_repository.dart';
import 'package:code_space_client/data/repositories/submission_repository.dart';
import 'package:code_space_client/data/repositories/user_repository.dart';
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

    sl.registerLazySingleton<AuthCubit>(() => AuthCubit(authRepository: sl()));

    sl.registerLazySingleton<UserService>(
      () => UserService(
        apiProvider: sl(),
        localStorage: sl(),
      ),
    );

    sl.registerLazySingleton<UserRepository>(
      () => UserRepository(userService: sl()),
    );

    sl.registerLazySingleton<UserCubit>(
      () => UserCubit(userRepository: sl()),
    );

    sl.registerLazySingleton<SubmissionService>(
      () => SubmissionService(
        apiProvider: sl(),
      ),
    );

    sl.registerLazySingleton<SubmissionRepository>(
      () => SubmissionRepository(submissionService: sl()),
    );

    sl.registerLazySingleton<ProblemService>(
      () => ProblemService(
        apiProvider: sl(),
      ),
    );

    sl.registerLazySingleton<ProblemRepository>(
      () => ProblemRepository(problemService: sl()),
    );

    sl.registerFactory<ProblemCubit>(
      () => ProblemCubit(
        submissionRepository: sl(),
        problemRepository: sl(),
      ),
    );

    sl.registerFactory<ProblemResultCubit>(
      () => ProblemResultCubit(submissionRepository: sl()),
    );

    sl.registerLazySingleton<LocaleService>(
      () => LocaleService(localStorage: sl()),
    );

    final language = await sl<LocaleService>().getLocaleLanguage();
    sl.registerLazySingleton<LocaleCubit>(
      () => LocaleCubit(
        localeService: sl(),
        initLanguage: language,
      ),
    );
  }
}
