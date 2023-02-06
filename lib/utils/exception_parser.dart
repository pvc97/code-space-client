import 'package:code_space_client/cubits/auth/auth_cubit.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/models/app_exception.dart';
import 'package:dio/dio.dart';

class ExceptionParser {
  ExceptionParser._();
  static AppException parse(dynamic error) {
    if (error is DioError) {
      if (error.response?.statusCode == 401) {
        // If unauthorized, logout user
        // Handle logout with AuthCubit here a little bit dirty
        // But it's easiest way
        sl<AuthCubit>().logout();
        return UnAuthorizedException(error.response?.data['error']);
      }

      final errorMessage =
          error.response?.data['error'] ?? S.current.have_error;

      return CommonException(message: errorMessage);
    }

    return CommonException(message: error.toString());
  }
}