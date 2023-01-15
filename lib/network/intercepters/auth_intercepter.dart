import 'dart:convert';
import 'package:code_space_client/constants/spref_key.dart';
import 'package:code_space_client/constants/status_code_constants.dart';
import 'package:code_space_client/constants/url_constants.dart';
import 'package:code_space_client/models/token_model.dart';
import 'package:code_space_client/utils/logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:code_space_client/data/local/local_storage_manager.dart';
import 'package:code_space_client/network/api_provider.dart';

/// Use QueuedInterceptorsWrapper get refresh token sequentially
/// when multiple requests are sent at the same time (all of this token is expired)
/// If use InterceptorsWrapper with _lastErrorStatus,
/// So when request is refreshing token, another request will not refresh token
/// => Error 401 will go to bloc
/// => User have to login again
class AuthIntercepter extends QueuedInterceptorsWrapper {
  final LocalStorageManager localStorage;
  final ApiProvider apiProvider;

  AuthIntercepter({
    required this.localStorage,
    required this.apiProvider,
  });

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d('statusCode: ${response.statusCode}}');
    return handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == StatusCodeConstants.code401) {
      logger.d('--------PUT INTO QUEUE');
      logger.d('HEADER: ${err.requestOptions.headers}');

      final errorAccessToken = (err.requestOptions
          .headers['Authorization']); // Result: 'Bearer $accessToken'

      final dioAccessToken = apiProvider.accessToken;

      if (errorAccessToken != dioAccessToken) {
        // Replace old access token with new access token from dio
        final headers = Map<String, dynamic>.from(err.requestOptions.headers);
        headers['Authorization'] = dioAccessToken;

        final resendRespone = await apiProvider.dio.request(
          err.requestOptions.path,
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
          options: Options(
            headers: headers,
            method: err.requestOptions.method,
            contentType: 'application/json; charset=utf-8',
            responseType: ResponseType.json,
          ),
        );
        return handler.resolve(resendRespone);
      }

      final tokenModelStr =
          await localStorage.read<String>(SPrefKey.tokenModel);

      if (tokenModelStr != null && tokenModelStr.isNotEmpty) {
        final tokenModel = TokenModel.fromJson(jsonDecode(tokenModelStr));
        await _refreshToken(refreshToken: tokenModel.refreshToken);

        final resendRespone = await apiProvider.dio.request(
          err.requestOptions.path,
        );

        return handler.resolve(resendRespone);
      }
    }

    return handler.next(err);
  }

  Future<void> _refreshToken({
    required String refreshToken,
  }) async {
    logger.d('Refresh token');
    final response = await apiProvider.post(
      UrlConstants.refreshToken,
      params: {
        'refreshToken': refreshToken,
      },
    );

    if (response?.statusCode == StatusCodeConstants.code200) {
      final tokenModel = TokenModel.fromJson(response?.data['data']);
      apiProvider.accessToken = tokenModel.accessToken;
      await localStorage.write<String>(
          SPrefKey.tokenModel, jsonEncode(tokenModel.toJson()));
    } else {
      // Invalid refresh token
      await localStorage.delete(SPrefKey.tokenModel);
    }
  }
}
