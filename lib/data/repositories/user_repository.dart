import 'package:code_space_client/models/teacher_model.dart';
import 'package:code_space_client/models/user_model.dart';
import 'package:code_space_client/data/data_provider/services/user_service.dart';
import 'package:code_space_client/utils/exception_parser.dart';

abstract class UserRepository {
  Future<UserModel> fetchUserInfo({required String userId});
  Future<UserModel?> getMe();
  Future<List<TeacherModel>> getTeachers();
  Future<List<UserModel>> getUsers({
    required String query,
    required int page,
    required int limit,
  });
  Future<UserModel> createUser({
    required String username,
    required String fullName,
    required String email,
    required String password,
    required String role,
  });
  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  });
  Future<UserModel> updateProfile({
    required String userId,
    required String fullName,
    required String email,
  });
  Future<bool> resetPassword({
    required String userId,
    required String newPassword,
  });
  Future<bool> deleteUser({required String userId});
  Future<UserModel> updateUser({
    required String userId,
    required String fullName,
    required String email,
  });
}

class UserRepositoryImpl implements UserRepository {
  final UserService userService;

  UserRepositoryImpl({
    required this.userService,
  });

  /// Fetch specific user info from server
  @override
  Future<UserModel> fetchUserInfo({required String userId}) async {
    try {
      final user = await userService.fetchUserInfo(userId: userId);
      return user;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  /// Get me: cached user info
  @override
  Future<UserModel?> getMe() async {
    return userService.getMe();
  }

  @override
  Future<List<TeacherModel>> getTeachers() async {
    try {
      final teachers = await userService.getTeachers();
      return teachers;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
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

  @override
  Future<UserModel> createUser({
    required String username,
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final user = await userService.createUser(
        username: username,
        fullName: fullName,
        email: email,
        password: password,
        role: role,
      );
      return user;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final success = await userService.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      return success;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<UserModel> updateProfile({
    required String userId,
    required String fullName,
    required String email,
  }) async {
    try {
      final user = await userService.updateProfile(
        userId: userId,
        fullName: fullName,
        email: email,
      );

      return user;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<bool> resetPassword({
    required String userId,
    required String newPassword,
  }) async {
    try {
      final success = await userService.resetPassword(
        userId: userId,
        newPassword: newPassword,
      );
      return success;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<bool> deleteUser({required String userId}) async {
    try {
      final success = await userService.deleteUser(userId: userId);
      return success;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  /// Manager update user info
  @override
  Future<UserModel> updateUser({
    required String userId,
    required String fullName,
    required String email,
  }) async {
    try {
      final user = await userService.updateUser(
        userId: userId,
        fullName: fullName,
        email: email,
      );
      return user;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }
}
