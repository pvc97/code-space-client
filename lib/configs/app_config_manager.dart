import 'package:code_space_client/configs/env_config_manager.dart';
import 'package:code_space_client/configs/environment_type.dart';
import 'package:code_space_client/const/network/url_constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfigManager {
  AppConfigManager._();

  static Future<void> init({required EnvironmentType environmentType}) async {
    await dotenv.load(fileName: environmentType.dotenvFilePath);

    EnvConfigManager.init(
      environmentType: environmentType,
      baseUrl: dotenv.env[UrlConstants.baseUrl]!,
    );

    final baseUrl = EnvConfigManager.instance.baseUrl;

    // TODO: Initialize api provider with baseUrl
    // await apiProvider.initApiProvider(baseUrl);
  }
}
