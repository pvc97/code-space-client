import 'dart:convert';

import 'package:code_space_client/constants/network_constants.dart';
import 'package:code_space_client/models/token_model.dart';
import 'package:dio/dio.dart';

import 'package:code_space_client/data/local/local_storage_manager.dart';
import 'package:code_space_client/network/api_provider.dart';

class AuthIntercepter extends InterceptorsWrapper {
  final LocalStorageManager localStorageManager;
  final ApiProvider apiProvider;

  AuthIntercepter({
    required this.localStorageManager,
    required this.apiProvider,
  });

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    super.onError(err, handler);

    if (err.response?.statusCode == 401) {
      final refreshToken = err.response?.data['refreshToken'];
      final tokenModel = await _refreshToken(refreshToken: refreshToken);

      final String? userAuth =
          await localStorageManager.read<String>(NetworkConstants.userAuth);
      if (userAuth != null && userAuth.isNotEmpty) {
        final userDecoded = jsonDecode(userAuth);
        userDecoded['accessToken'] = tokenModel.accessToken;
        userDecoded['refreshToken'] = tokenModel.refreshToken;
      }

      apiProvider.setHeader(accessToken: tokenModel.accessToken);

      final resendRespone = await apiProvider.post(
        err.requestOptions.path,
        params: err.requestOptions.data,
      );

      handler.resolve(resendRespone!);
    }
  }

  Future<TokenModel> _refreshToken({
    required String refreshToken,
  }) async {
    final response = await apiProvider.post(
      '/auth/refresh-token',
      params: {
        'refreshToken': refreshToken,
      },
    );

    return TokenModel.fromJson(response?.data);
  }
}
