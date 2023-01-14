import 'package:code_space_client/models/user_model.dart';
import 'package:code_space_client/services/user_service.dart';

class UserRepository {
  final UserService userService;

  UserRepository({
    required this.userService,
  });

  Future<UserModel> getUserInfo() async {
    return userService.getUserInfo();
  }
}
