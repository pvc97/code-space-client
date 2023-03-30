import 'dart:convert';

import 'package:code_space_client/constants/spref_key.dart';
import 'package:code_space_client/constants/status_code_constants.dart';
import 'package:code_space_client/constants/url_constants.dart';
import 'package:code_space_client/data/data_provider/local/local_storage_manager.dart';
import 'package:code_space_client/data/data_provider/network/api_provider.dart';
import 'package:code_space_client/models/teacher_model.dart';
import 'package:code_space_client/models/user_model.dart';

abstract class UserService {
  Future<UserModel> fetchUserInfo({required String userId});
  Future<UserModel?> getMe();
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getLocalUser();
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

class UserServiceImpl implements UserService {
  final ApiProvider apiProvider;
  final LocalStorageManager localStorage;

  UserModel? me;

  UserServiceImpl({
    required this.apiProvider,
    required this.localStorage,
  });

  /// Fetch user info with id from server
  @override
  Future<UserModel> fetchUserInfo({required String userId}) async {
    final response = await apiProvider.get('${UrlConstants.users}/$userId');
    return UserModel.fromJson(response?.data['data']);
  }

  /// Get user cached user info
  /// If user is null, get user info from local storage
  /// Use cached user to improve performance :)
  @override
  Future<UserModel?> getMe() async {
    if (me != null) {
      return me;
    }

    return getLocalUser();
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
  Future<List<TeacherModel>> getTeachers() async {
    final response = await apiProvider.get(
      UrlConstants.users,
      queryParameters: {
        'roleType': 'teacher',
        'all': true,
      },
    );
    final teachers = response?.data['data'] as List;
    return teachers.map((e) => TeacherModel.fromJson(e)).toList();
  }

  @override
  Future<List<UserModel>> getUsers({
    required String query,
    required int page,
    required int limit,
  }) async {
    final response = await apiProvider.get(
      UrlConstants.users,
      queryParameters: {
        'page': page,
        'q': query,
        'limit': limit,
        'all': false,
        // if all == true => don't use pagination, otherwise use pagination,
      },
    );
    final users = response?.data['data'] as List;
    return users.map((e) => UserModel.fromJson(e)).toList();
  }

  @override
  Future<UserModel> createUser({
    required String username,
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await apiProvider.post(
      UrlConstants.users,
      params: {
        'username': username,
        'name': fullName,
        'email': email,
        'password': password,
        'roleType': role,
      },
    );
    return UserModel.fromJson(response?.data['data']);
  }

  @override
  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final response = await apiProvider.post(
      UrlConstants.changePassword,
      params: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      },
    );

    if (response?.statusCode == StatusCodeConstants.code200) {
      return true;
    }

    return false;
  }

  @override
  Future<UserModel> updateProfile({
    required String userId,
    required String fullName,
    required String email,
  }) async {
    final response = await apiProvider.put(
      '${UrlConstants.users}/$userId',
      params: {
        'name': fullName,
        'email': email,
      },
    );

    final user = UserModel.fromJson(response?.data['data']);

    // Update local user
    saveUser(user);

    return user;
  }

  /// Manager reset password
  @override
  Future<bool> resetPassword({
    required String userId,
    required String newPassword,
  }) async {
    final response = await apiProvider.post(
      UrlConstants.resetPassword,
      params: {
        'userId': userId,
        'newPassword': newPassword,
      },
    );

    if (response?.statusCode == StatusCodeConstants.code200) {
      return true;
    }

    return false;
  }

  /// Manager delete user
  @override
  Future<bool> deleteUser({required String userId}) async {
    final response = await apiProvider.delete('${UrlConstants.users}/$userId');

    if (response?.statusCode == StatusCodeConstants.code200) {
      return true;
    }

    return false;
  }

  // Manager update user
  @override
  Future<UserModel> updateUser({
    required String userId,
    required String fullName,
    required String email,
  }) async {
    final response = await apiProvider.put(
      '${UrlConstants.users}/$userId',
      params: {
        'name': fullName,
        'email': email,
      },
    );

    return UserModel.fromJson(response?.data['data']);
  }
}
