import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:code_space_client/configs/env_config_manager.dart';
import 'package:code_space_client/configs/environment_type.dart';
import 'package:code_space_client/constants/network_constants.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/data/data_provider/network/api_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class AppConfigManager {
  AppConfigManager._();

  static Future<void> init({required EnvironmentType environmentType}) async {
    // TODO: Remove this if statement when deploying to web
    if (kIsWeb) {
      environmentType = EnvironmentType.devWeb;
    }

    await dotenv.load(fileName: environmentType.dotenvFilePath);

    EnvConfigManager.init(
      environmentType: environmentType,
      baseUrl: dotenv.env[NetworkConstants.baseUrl]!,
    );

    final baseUrl = EnvConfigManager.instance.baseUrl;

    final apiProvider = sl<ApiProvider>();
    await apiProvider.init(baseUrl: baseUrl);
  }
}
