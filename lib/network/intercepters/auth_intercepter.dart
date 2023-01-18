import 'dart:convert';
import 'package:code_space_client/constants/spref_key.dart';
import 'package:code_space_client/constants/status_code_constants.dart';
import 'package:code_space_client/constants/url_constants.dart';
import 'package:code_space_client/models/token_model.dart';
import 'package:code_space_client/utils/logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:code_space_client/data/local/local_storage_manager.dart';
import 'package:code_space_client/network/api_provider.dart';

/// This Interceptor is inpired by official example of Dio
/// https://github.com/flutterchina/dio/blob/develop/example/lib/queued_interceptor_crsftoken.dart
///
/// Use QueuedInterceptorsWrapper to get refresh token sequentially
/// when multiple requests are sent at the same time, and all of them have expired access token
/// => Only one request will be sent to refresh token
/// => Other requests will be queued and use the new access token from the first request
///
/// This Interceptor has a bug when retry with dio.fetch(requestOptions)
/// if has error, no error will be thrown
/// https://github.com/flutterchina/dio/issues/1612
/// Right now doesn't have any solution for this bug >.<
/// TODO: Check github issue to see if there is any solution
class AuthIntercepter extends InterceptorsWrapper {
  final LocalStorageManager localStorage;
  final ApiProvider apiProvider;

  final freelanceDio = Dio();

  AuthIntercepter({
    required this.localStorage,
    required this.apiProvider,
  });

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    // logger.d('AuthIntercepter onError: ${err.response?.statusCode}');
    apiProvider.dio.interceptors.errorLock.lock();
    if (err.response?.statusCode == StatusCodeConstants.code401) {
      // errorAccessToken: 'Bearer accessToken'
      // This access token is expired and cause error 401
      final errorAccessToken = (err.requestOptions.headers['Authorization']);

      // Compare error access token with current access token from dio
      // If they are different, it means that the access token has been refreshed
      // => Do not refresh token again, just retry request with new access token
      if (errorAccessToken != apiProvider.accessToken) {
        try {
          final res = await _retry(err.requestOptions);
          apiProvider.dio.interceptors.errorLock.unlock();
          // Note: when call handler.resolve(res), PrettyDioLogger don't log response
          return handler.resolve(res);
        } on DioError catch (retryError) {
          apiProvider.dio.interceptors.errorLock.unlock();
          return handler.reject(retryError);
        }
      }

      // Read refreshToken from local storage to refresh token
      final tokenModelStr =
          await localStorage.read<String>(SPrefKey.tokenModel);

      if (tokenModelStr != null && tokenModelStr.isNotEmpty) {
        try {
          final tokenModel = TokenModel.fromJson(jsonDecode(tokenModelStr));
          await _refreshToken(refreshToken: tokenModel.refreshToken);

          try {
            final res = await _retry(err.requestOptions);
            apiProvider.dio.interceptors.errorLock.unlock();
            // Note: when call handler.resolve(res), PrettyDioLogger don't log response
            return handler.resolve(res);
          } on DioError catch (retryError) {
            apiProvider.dio.interceptors.errorLock.unlock();
            return handler.reject(retryError);
          }
        } catch (e) {
          apiProvider.dio.interceptors.errorLock.unlock();
          return handler.reject(err);
        }
      }
    }

    apiProvider.dio.interceptors.errorLock.unlock();
    return handler.next(err);
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    // Use another dio instance to retry request with same reason in _refreshToken
    try {
      freelanceDio.options = apiProvider.dio.options.copyWith();
      requestOptions.headers['Authorization'] = apiProvider.accessToken;
      final response = await freelanceDio.fetch(requestOptions);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _refreshToken({required String refreshToken}) async {
    try {
      // Before refresh token, I've already locked errorLock
      // If I still use apiProvider.dio and if refresh token is invalid
      // => DioError occurs but errorLock is still locked, no thing can handle this error
      // So I have to create a new dio instance to refresh token to avoid deadlock
      freelanceDio.options = apiProvider.dio.options.copyWith();
      logger.d('Refresh token');
      final response = await freelanceDio.post(
        UrlConstants.refreshToken,
        data: {
          'refreshToken': refreshToken,
        },
      );

      if (response.statusCode == StatusCodeConstants.code200) {
        final tokenModel = TokenModel.fromJson(response.data['data']);

        // Update new access token to dio
        apiProvider.accessToken = tokenModel.accessToken;

        // Save new tokenModel to local storage
        await localStorage.write<String>(
            SPrefKey.tokenModel, jsonEncode(tokenModel.toJson()));
      }
    } catch (e) {
      // Delete local storage data if refresh token is invalid
      // User have to login again
      await localStorage.deleteAll();
      rethrow;
    }
  }
}
