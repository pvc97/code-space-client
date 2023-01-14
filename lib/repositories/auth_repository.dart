import 'package:code_space_client/models/user_model.dart';
import 'package:code_space_client/services/auth/auth_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthRepository {
  final AuthService authService;

  AuthRepository({required this.authService});

  Future<UserModel> login({
    required String userName,
    required String password,
  }) async {
    final tokenModel =
        await authService.login(userName: userName, password: password);

    final UserModel user =
        UserModel.fromJson(JwtDecoder.decode(tokenModel.accessToken));

    return user;
  }
}
