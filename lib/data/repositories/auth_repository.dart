import 'package:code_space_client/models/token_model.dart';
import 'package:code_space_client/models/user_model.dart';
import 'package:code_space_client/data/data_provider/services/auth_service.dart';
import 'package:code_space_client/utils/exception_parser.dart';

class AuthRepository {
  final AuthService authService;

  AuthRepository({required this.authService});

  Future<UserModel> login({
    required String userName,
    required String password,
  }) async {
    try {
      final user =
          await authService.login(userName: userName, password: password);
      return user;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  Future<void> logout() => authService.logout();

  Future<void> saveUser(UserModel user) => authService.saveUser(user);

  Future<UserModel?> getSavedUser() => authService.getLocalUser();

  Future<TokenModel?> getSavedToken() => authService.getLocalToken();

  Future<bool> isLoggedIn() => authService.isLoggedIn();
}
