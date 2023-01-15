import 'dart:convert';
import 'package:code_space_client/constants/spref_key.dart';
import 'package:code_space_client/constants/url_constants.dart';
import 'package:code_space_client/models/token_model.dart';
import 'package:dio/dio.dart';
import 'package:code_space_client/data/local/local_storage_manager.dart';
import 'package:code_space_client/network/api_provider.dart';

class AuthIntercepter extends InterceptorsWrapper {
  final LocalStorageManager localStorage;
  final ApiProvider apiProvider;

  AuthIntercepter({
    required this.localStorage,
    required this.apiProvider,
  });

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
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
    final response = await apiProvider.post(
      UrlConstants.refreshToken,
      params: {
        'refreshToken': refreshToken,
      },
    );

    if (response?.statusCode == 200) {
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
