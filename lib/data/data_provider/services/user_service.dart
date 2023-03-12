import 'dart:convert';

import 'package:code_space_client/constants/spref_key.dart';
import 'package:code_space_client/constants/status_code_constants.dart';
import 'package:code_space_client/constants/url_constants.dart';
import 'package:code_space_client/data/data_provider/local/local_storage_manager.dart';
import 'package:code_space_client/data/data_provider/network/api_provider.dart';
import 'package:code_space_client/models/teacher_model.dart';
import 'package:code_space_client/models/user_model.dart';

class UserService {
  final ApiProvider apiProvider;
  final LocalStorageManager localStorage;

  UserModel? me;

  UserService({
    required this.apiProvider,
    required this.localStorage,
  });

  /// Fetch user info with id from server
  Future<UserModel> fetchUserInfo({required String userId}) async {
    final response = await apiProvider.get('${UrlConstants.users}/$userId');
    return UserModel.fromJson(response?.data['data']);
  }

  /// Get user cached user info
  /// If user is null, get user info from local storage
  /// Use cached user to improve performance :)
  Future<UserModel?> getMe() async {
    if (me != null) {
      return me;
    }

    return getLocalUser();
  }

  Future<void> saveUser(UserModel user) async {
    await localStorage.write<String>(
        SPrefKey.userModel, jsonEncode(user.toJson()));
  }

  Future<UserModel?> getLocalUser() async {
    final userJson = await localStorage.read<String>(SPrefKey.userModel);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

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

  Future<List<UserModel>> getUsers({
    required String query,
    required int page,
    required int limit,
    bool onlyLast = false,
  }) async {
    final response = await apiProvider.get(
      UrlConstants.users,
      queryParameters: {
        'page': page,
        'q': query,
        'limit': limit,
        'all': false,
        // if all == true => don't use pagination, otherwise use pagination,
        'onlyLast': onlyLast,
      },
    );
    final users = response?.data['data'] as List;
    return users.map((e) => UserModel.fromJson(e)).toList();
  }

  Future<String> createUser({
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
    return response?.data['data']['id'];
  }

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
  Future<bool> deleteUser({required String userId}) async {
    final response = await apiProvider.delete('${UrlConstants.users}/$userId');

    if (response?.statusCode == StatusCodeConstants.code200) {
      return true;
    }

    return false;
  }

  // Manager update user
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
