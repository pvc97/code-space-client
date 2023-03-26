import 'package:code_space_client/blocs/auth/auth_cubit.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/models/app_exception.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:code_space_client/utils/logger/logger.dart';
import 'package:dio/dio.dart';

class ExceptionParser {
  ExceptionParser._();
  static AppException parse(dynamic error) {
    logger.d('ExceptionParser: $error');

    if (error is DioError) {
      if (error.response?.statusCode == 401) {
        // If unauthorized, logout user
        // Handle logout with AuthCubit here a little bit dirty
        // But it's easiest way
        sl<AuthCubit>().logout();
        return UnAuthorizedException(error.response?.data['error']);
      }

      final errorMessage = error.response?.data['error'] ??
          S.of(AppRouter.context).an_error_occurred;

      return AppException(
          code: error.response?.statusCode ?? 0, message: errorMessage);
    }

    return CommonException(message: error.toString());
  }
}
