import 'package:code_space_client/blocs/account/account_cubit.dart';
import 'package:code_space_client/blocs/auth/auth_cubit.dart';
import 'package:code_space_client/blocs/course/course_bloc.dart';
import 'package:code_space_client/blocs/course_detail/course_detail_bloc.dart';
import 'package:code_space_client/blocs/create_account/create_account_cubit.dart';
import 'package:code_space_client/blocs/create_course/create_course_cubit.dart';
import 'package:code_space_client/blocs/create_problem/create_problem_cubit.dart';
import 'package:code_space_client/blocs/change_password/change_password_cubit.dart';
import 'package:code_space_client/blocs/locale/locale_cubit.dart';
import 'package:code_space_client/blocs/problem/problem_cubit.dart';
import 'package:code_space_client/blocs/problem_result/problem_result_cubit.dart';
import 'package:code_space_client/blocs/ranking/ranking_cubit.dart';
import 'package:code_space_client/blocs/reset_password/reset_password_cubit.dart';
import 'package:code_space_client/blocs/update_account/update_account_cubit.dart';
import 'package:code_space_client/blocs/update_course/update_course_cubit.dart';
import 'package:code_space_client/blocs/user/user_cubit.dart';
import 'package:code_space_client/data/data_provider/local/local_storage_manager.dart';
import 'package:code_space_client/data/data_provider/local/local_storage_manager_impl.dart';
import 'package:code_space_client/data/data_provider/network/api_provider.dart';
import 'package:code_space_client/data/data_provider/network/intercepters/auth_intercepter.dart';
import 'package:code_space_client/data/data_provider/services/course_service.dart';
import 'package:code_space_client/data/data_provider/services/language_service.dart';
import 'package:code_space_client/data/data_provider/services/locale_service.dart';
import 'package:code_space_client/data/data_provider/services/problem_service.dart';
import 'package:code_space_client/data/data_provider/services/submission_service.dart';
import 'package:code_space_client/data/repositories/auth_repository.dart';
import 'package:code_space_client/data/data_provider/services/auth_service.dart';
import 'package:code_space_client/data/data_provider/services/user_service.dart';
import 'package:code_space_client/data/repositories/course_repository.dart';
import 'package:code_space_client/data/repositories/language_repository.dart';
import 'package:code_space_client/data/repositories/locale_repository.dart';
import 'package:code_space_client/data/repositories/problem_repository.dart';
import 'package:code_space_client/data/repositories/submission_repository.dart';
import 'package:code_space_client/data/repositories/user_repository.dart';
import 'package:code_space_client/models/languages.dart';
import 'package:code_space_client/presentation/problem/widgets/result_dialog/result_dialog_cubit.dart';
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
      () => AuthServiceImpl(
        apiProvider: sl(),
        localStorage: sl(),
      ),
    );

    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(authService: sl()),
    );

    sl.registerLazySingleton<AuthCubit>(() => AuthCubit(authRepository: sl()));

    sl.registerLazySingleton<UserService>(
      () => UserServiceImpl(
        apiProvider: sl(),
        localStorage: sl(),
      ),
    );

    sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(userService: sl()),
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
      () => ProblemServiceImpl(
        apiProvider: sl(),
      ),
    );

    sl.registerLazySingleton<ProblemRepository>(
      () => ProblemRepositoryImpl(problemService: sl()),
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
      () => LocaleServiceImpl(localStorage: sl(), apiProvider: sl()),
    );

    sl.registerLazySingleton<LocaleRepository>(
      () => LocaleRepositoryImpl(localeService: sl()),
    );

    final languageCode = await sl<LocaleRepository>().getLocaleCode();
    sl.registerLazySingleton<LocaleCubit>(
      () => LocaleCubit(
        localeRepository: sl(),
        initLanguage: languageCode.toLanguage,
      ),
    );

    sl.registerLazySingleton<CourseService>(
      () => CourseServiceImpl(apiProvider: sl()),
    );

    sl.registerLazySingleton<CourseRepository>(
      () => CourseRepositoryImpl(courseService: sl()),
    );

    sl.registerFactory<CourseDetailBloc>(
      () => CourseDetailBloc(
        courseRepository: sl(),
        problemRepository: sl(),
      ),
    );

    sl.registerFactory<CourseBloc>(() => CourseBloc(courseRepository: sl()));

    sl.registerFactory<CreateCourseCubit>(
        () => CreateCourseCubit(userRepository: sl(), courseRepository: sl()));

    sl.registerLazySingleton<LanguageService>(
      () => LanguageServiceImpl(apiProvider: sl()),
    );

    sl.registerLazySingleton<LanguageRepository>(
      () => LanguageRepositoryImpl(languageService: sl()),
    );

    sl.registerFactory<CreateProblemCubit>(() =>
        CreateProblemCubit(languageRepository: sl(), problemRepository: sl()));

    sl.registerFactory<RankingCubit>(
        () => RankingCubit(courseRepository: sl()));

    sl.registerFactory<AccountCubit>(() => AccountCubit(userRepository: sl()));

    sl.registerFactory<CreateAccountCubit>(
      () => CreateAccountCubit(
        userRepository: sl(),
      ),
    );

    sl.registerFactory<ChangePasswordCubit>(
      () => ChangePasswordCubit(
        userRepository: sl(),
      ),
    );

    sl.registerFactory<ResetPasswordCubit>(
      () => ResetPasswordCubit(
        userRepository: sl(),
      ),
    );

    sl.registerFactory<UpdateAccountCubit>(
      () => UpdateAccountCubit(userRepository: sl()),
    );

    sl.registerFactory<UpdateCourseCubit>(
      () => UpdateCourseCubit(
        courseRepository: sl(),
        userRepository: sl(),
      ),
    );

    sl.registerFactory<ResultDialogCubit>(() => ResultDialogCubit());
  }
}
