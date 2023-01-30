import 'package:code_space_client/models/token_model.dart';
import 'package:code_space_client/models/user_model.dart';
import 'package:code_space_client/data/data_provider/services/auth_service.dart';

class AuthRepository {
  final AuthService authService;

  AuthRepository({required this.authService});

  Future<UserModel> login({
    required String userName,
    required String password,
  }) {
    return authService.login(userName: userName, password: password);
  }

  Future<void> logout() => authService.logout();

  Future<void> saveUser(UserModel user) => authService.saveUser(user);

  Future<UserModel?> getSavedUser() => authService.getLocalUser();

  Future<TokenModel?> getSavedToken() => authService.getLocalToken();

  Future<bool> isLoggedIn() => authService.isLoggedIn();
}
