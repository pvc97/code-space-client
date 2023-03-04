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

  UserModel? me;

  UserService({
    required this.apiProvider,
    required this.localStorage,
  });

  /// Fetch user info with id from server
  Future<UserModel> fetchUserInfo(String userId) async {
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
}
