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
}
