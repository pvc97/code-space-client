import 'package:code_space_client/models/user_model.dart';
import 'package:code_space_client/data/data_provider/services/user_service.dart';

class UserRepository {
  final UserService userService;

  UserRepository({
    required this.userService,
  });

  /// Fetch user info from server
  Future<UserModel> fetchUserInfo() async {
    return userService.fetchUserInfo();
  }

  /// Get user cached user info
  Future<UserModel?> getUserInfo() async {
    return userService.getUserInfo();
  }
}
