import 'dart:convert';

import 'package:code_space_client/constants/spref_key.dart';
import 'package:code_space_client/constants/url_constants.dart';
import 'package:code_space_client/data/data_provider/local/local_storage_manager.dart';
import 'package:code_space_client/models/token_model.dart';
import 'package:code_space_client/data/data_provider/network/api_provider.dart';

class AuthService {
  final ApiProvider apiProvider;
  final LocalStorageManager localStorage;

  AuthService({
    required this.apiProvider,
    required this.localStorage,
  });

  Future<TokenModel> login({
    required String userName,
    required String password,
  }) async {
    final response = await apiProvider.post(
      UrlConstants.login,
      params: {
        'username': userName,
        'password': password,
      },
    );

    final tokenModel = TokenModel.fromJson(response?.data['data']);

    apiProvider.accessToken = tokenModel.accessToken;
    await localStorage.write<String>(
        SPrefKey.tokenModel, jsonEncode(tokenModel.toJson()));

    return tokenModel;
  }
}
