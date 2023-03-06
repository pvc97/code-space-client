import 'package:code_space_client/models/teacher_model.dart';
import 'package:code_space_client/models/user_model.dart';
import 'package:code_space_client/data/data_provider/services/user_service.dart';
import 'package:code_space_client/utils/exception_parser.dart';

class UserRepository {
  final UserService userService;

  UserRepository({
    required this.userService,
  });

  /// Fetch specific user info from server
  Future<UserModel> fetchUserInfo(String problemId) async {
    try {
      final user = await userService.fetchUserInfo(problemId);
      return user;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  /// Get me: cached user info
  Future<UserModel?> getMe() async {
    return userService.getMe();
  }

  Future<List<TeacherModel>> getTeachers() async {
    try {
      final teachers = await userService.getTeachers();
      return teachers;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  Future<List<UserModel>> getUsers({
    required String query,
    required int page,
    required int limit,
  }) async {
    try {
      final users = await userService.getUsers(
        query: query,
        page: page,
        limit: limit,
      );
      return users;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  Future<String> createUser({
    required String username,
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final userId = await userService.createUser(
        username: username,
        fullName: fullName,
        email: email,
        password: password,
        role: role,
      );
      return userId;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }
}
