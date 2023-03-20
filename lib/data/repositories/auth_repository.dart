import 'package:code_space_client/models/token_model.dart';
import 'package:code_space_client/models/user_model.dart';
import 'package:code_space_client/data/data_provider/services/auth_service.dart';
import 'package:code_space_client/utils/exception_parser.dart';

abstract class AuthRepository {
  Future<UserModel> login({
    required String userName,
    required String password,
  });
  Future<void> logout();
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getSavedUser();
  Future<TokenModel?> getSavedToken();
  Future<bool> isLoggedIn();
  Future<bool> registerStudent({
    required String username,
    required String fullName,
    required String email,
    required String password,
  });
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;

  AuthRepositoryImpl({required this.authService});

  @override
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

  @override
  Future<void> logout() => authService.logout();

  @override
  Future<void> saveUser(UserModel user) => authService.saveUser(user);

  @override
  Future<UserModel?> getSavedUser() => authService.getLocalUser();

  @override
  Future<TokenModel?> getSavedToken() => authService.getLocalToken();

  @override
  Future<bool> isLoggedIn() => authService.isLoggedIn();

  @override
  Future<bool> registerStudent({
    required String username,
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final success = await authService.registerStudent(
        username: username,
        fullName: fullName,
        email: email,
        password: password,
      );
      return success;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }
}
