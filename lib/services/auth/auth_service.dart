import 'package:code_space_client/constants/status_code_constants.dart';
import 'package:code_space_client/models/token_model.dart';
import 'package:code_space_client/models/user_auth_model.dart';
import 'package:code_space_client/network/api_provider.dart';
import 'package:code_space_client/utils/logger/logger.dart';

class AuthService {
  final ApiProvider _apiProvider;

  AuthService(this._apiProvider);

  Future<UserAuthModel> login({
    required String userName,
    required String password,
  }) async {
    final response = await _apiProvider.post(
      '/auth/login',
      params: {
        'userName': userName,
        'password': password,
      },
    );

    return UserAuthModel.fromJson(response?.data);
  }
}
