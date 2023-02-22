import 'dart:convert';

import 'package:code_space_client/constants/spref_key.dart';
import 'package:code_space_client/constants/url_constants.dart';
import 'package:code_space_client/data/data_provider/local/local_storage_manager.dart';
import 'package:code_space_client/data/data_provider/network/api_provider.dart';
import 'package:code_space_client/models/teacher_model.dart';
import 'package:code_space_client/models/user_model.dart';

class UserService {
  final ApiProvider apiProvider;
  final LocalStorageManager localStorage;

  UserModel? user;

  UserService({
    required this.apiProvider,
    required this.localStorage,
  });

  /// Fetch user info from server
  Future<UserModel> fetchUserInfo() async {
    final response = await apiProvider.get(UrlConstants.userInfo);
    user = UserModel.fromJson(response?.data['data']);
    await saveUser(user!);
    return user!;
  }

  /// Get user cached user info
  /// If user is null, get user info from local storage
  /// Use cached user to improve performance :)
  Future<UserModel?> getUserInfo() async {
    if (user != null) {
      return user;
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
    final response = await apiProvider.get(UrlConstants.teachers);
    final teachers = response?.data['data'] as List;
    return teachers.map((e) => TeacherModel.fromJson(e)).toList();
  }
}
