import 'dart:convert';

import 'package:code_space_client/constants/app_constants.dart';
import 'package:code_space_client/constants/spref_key.dart';
import 'package:code_space_client/constants/status_code_constants.dart';
import 'package:code_space_client/constants/url_constants.dart';
import 'package:code_space_client/data/data_provider/local/local_storage_manager.dart';
import 'package:code_space_client/models/token_model.dart';
import 'package:code_space_client/data/data_provider/network/api_provider.dart';
import 'package:code_space_client/models/user_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

abstract class AuthService {
  Future<UserModel> login({
    required String userName,
    required String password,
  });

  Future<void> logout();

  Future<void> saveUser(UserModel user);

  Future<UserModel?> getLocalUser();

  Future<TokenModel?> getLocalToken();

  Future<bool> isLoggedIn();

  Future<bool> registerStudent({
    required String username,
    required String fullName,
    required String email,
    required String password,
  });
}

class AuthServiceImpl implements AuthService {
  final ApiProvider apiProvider;
  final LocalStorageManager localStorage;

  AuthServiceImpl({
    required this.apiProvider,
    required this.localStorage,
  });

  @override
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

  @override
  Future<void> logout() async {
    final tokenModel = await getLocalToken();
    final refreshToken = tokenModel?.refreshToken;

    final fcmToken = AppConstants.supportNotification
        ? await FirebaseMessaging.instance.getToken()
        : null;

    // I don't need await here because I want user can logout right away
    apiProvider.post(
      UrlConstants.logout,
      params: {
        'refreshToken': refreshToken,
        'fcmToken': fcmToken,
      },
    );

    localStorage.deleteAll(exceptKeys: SPrefKey.exceptKeys);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    await localStorage.write<String>(
        SPrefKey.userModel, jsonEncode(user.toJson()));
  }

  @override
  Future<UserModel?> getLocalUser() async {
    final userJson = await localStorage.read<String>(SPrefKey.userModel);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  @override
  Future<TokenModel?> getLocalToken() async {
    final tokenJson = await localStorage.read<String>(SPrefKey.tokenModel);
    if (tokenJson != null) {
      return TokenModel.fromJson(jsonDecode(tokenJson));
    }
    return null;
  }

  @override
  Future<bool> isLoggedIn() async {
    final listData = await Future.wait([
      getLocalUser(),
      getLocalToken(),
    ]);

    final savedUser = listData[0];
    final savedToken = listData[1];

    return savedUser != null && savedToken != null;
  }

  @override
  Future<bool> registerStudent({
    required String username,
    required String fullName,
    required String email,
    required String password,
  }) async {
    final response = await apiProvider.post(
      UrlConstants.register,
      params: {
        'username': username,
        'name': fullName,
        'email': email,
        'password': password,
      },
    );

    if (response?.statusCode != StatusCodeConstants.code201) {
      return false;
    }

    final tokenModel = TokenModel.fromJson(response?.data['data']);

    apiProvider.accessToken = tokenModel.accessToken;
    await localStorage.write<String>(
        SPrefKey.tokenModel, jsonEncode(tokenModel.toJson()));

    final UserModel user =
        UserModel.fromJson(JwtDecoder.decode(tokenModel.accessToken));

    await saveUser(user);

    return true;
  }
}
