import 'package:code_space_client/constants/url_constants.dart';
import 'package:code_space_client/models/custom_error.dart';
import 'package:code_space_client/models/user_model.dart';
import 'package:code_space_client/network/api_provider.dart';

class UserService {
  final ApiProvider apiProvider;

  UserService(this.apiProvider);

  Future<UserModel> getUserInfo() async {
    final response = await apiProvider.get(UrlConstants.userInfo);

    if (response?.statusCode == 200) {
      return UserModel.fromJson(response?.data['data']);
    }

    throw CustomError(message: response?.data['error']);
  }
}
