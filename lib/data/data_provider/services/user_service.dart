import 'package:code_space_client/constants/url_constants.dart';
import 'package:code_space_client/models/custom_error.dart';
import 'package:code_space_client/models/user_model.dart';
import 'package:code_space_client/data/data_provider/network/api_provider.dart';
import 'package:code_space_client/utils/logger/logger.dart';

class UserService {
  final ApiProvider apiProvider;

  UserService({required this.apiProvider});

  Future<UserModel> getUserInfo() async {
    final response = await apiProvider.get(UrlConstants.userInfo);

    if (response?.statusCode == 200) {
      final user = UserModel.fromJson(response?.data['data']);
      logger.d('User: ${user.name}');
      return user;
    }

    throw CustomError(message: response?.data['error']);
  }
}
