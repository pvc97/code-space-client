import 'package:code_space_client/constants/url_constants.dart';
import 'package:code_space_client/models/token_model.dart';
import 'package:code_space_client/network/api_provider.dart';

class AuthService {
  final ApiProvider _apiProvider;

  AuthService(this._apiProvider);

  Future<TokenModel> login({
    required String userName,
    required String password,
  }) async {
    final response = await _apiProvider.post(
      UrlConstants.login,
      params: {
        'username': userName,
        'password': password,
      },
    );

    return TokenModel.fromJson(response?.data['data']);
  }
}
