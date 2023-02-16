import 'dart:convert';

import 'package:code_space_client/constants/spref_key.dart';
import 'package:code_space_client/constants/url_constants.dart';
import 'package:code_space_client/data/data_provider/local/local_storage_manager.dart';
import 'package:code_space_client/models/token_model.dart';
import 'package:code_space_client/data/data_provider/network/api_provider.dart';
import 'package:code_space_client/models/user_model.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  final ApiProvider apiProvider;
  final LocalStorageManager localStorage;

  AuthService({
    required this.apiProvider,
    required this.localStorage,
  });

  Future<UserModel> login({
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

    final UserModel user =
        UserModel.fromJson(JwtDecoder.decode(tokenModel.accessToken));

    await saveUser(user);

    return user;
  }

  Future<void> logout() =>
      localStorage.deleteAll(exceptKeys: SPrefKey.exceptKeys);

  Future<void> saveUser(UserModel user) async {
    await localStorage.write<String>(
        SPrefKey.userModel, jsonEncode(user.toJson()));
  }

  Future<UserModel?> getLocalUser() async {
    final userJson = await localStorage.read<String>(SPrefKey.userModel);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<TokenModel?> getLocalToken() async {
    final tokenJson = await localStorage.read<String>(SPrefKey.tokenModel);
    if (tokenJson != null) {
      return TokenModel.fromJson(jsonDecode(tokenJson));
    }
    return null;
  }

  Future<bool> isLoggedIn() async {
    final listData = await Future.wait([
      getLocalUser(),
      getLocalToken(),
    ]);

    final savedUser = listData[0];
    final savedToken = listData[1];

    return savedUser != null && savedToken != null;
  }
}
