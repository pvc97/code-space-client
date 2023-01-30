import 'package:code_space_client/models/app_exception.dart';
import 'package:dio/dio.dart';

class ExceptionParser {
  ExceptionParser._();
  static AppException parse(dynamic error) {
    if (error is DioError) {
      if (error.response?.statusCode == 401) {
        return UnAuthorizedException(error.response?.data['error']);
      }
      return CommonException(message: error.response?.data['error']);
    }

    return CommonException(message: error.toString());
  }
}
