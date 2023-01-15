import 'dart:convert';
import 'package:code_space_client/constants/spref_key.dart';
import 'package:code_space_client/constants/status_code_constants.dart';
import 'package:code_space_client/constants/url_constants.dart';
import 'package:code_space_client/models/token_model.dart';
import 'package:code_space_client/utils/logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:code_space_client/data/local/local_storage_manager.dart';
import 'package:code_space_client/network/api_provider.dart';

// Use QueuedInterceptorsWrapper get refresh token sequentially
// when multiple requests are sent at the same time (all of this token is expired)
// If use InterceptorsWrapper with _lastErrorStatus,
// So when request is refreshing token, another request will not refresh token
// => Error 401 will go to bloc
// => User have to login again
class AuthIntercepter extends QueuedInterceptorsWrapper {
  final LocalStorageManager localStorage;
  final ApiProvider apiProvider;

  int? _lastErrorStatus;

  AuthIntercepter({
    required this.localStorage,
    required this.apiProvider,
  });

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _lastErrorStatus = response.statusCode;
    return handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    // If last error status is 401, we don't need to resend request
    // to prevent infinite loop
    // Only handle 401 error once
    if (err.response?.statusCode == StatusCodeConstants.code401 &&
        _lastErrorStatus != StatusCodeConstants.code401) {
      _lastErrorStatus = StatusCodeConstants.code401;

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

    _lastErrorStatus = err.response?.statusCode;
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
