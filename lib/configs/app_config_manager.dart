import 'dart:io';

import 'package:code_space_client/constants/app_images.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:code_space_client/configs/env_config_manager.dart';
import 'package:code_space_client/configs/environment_type.dart';
import 'package:code_space_client/constants/network_constants.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/data/data_provider/network/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';

abstract class AppConfigManager {
  AppConfigManager._();

  // Cache images will be loaded with precacheImage in didChangeDependencies of MyApp
  static List<AssetImage> imagesToCache = [
    const AssetImage(AppImages.courseDescriptionBackground),
    const AssetImage(AppImages.notFound),
  ];

  static Future<void> init({required EnvironmentType environmentType}) async {
    // TODO: Remove this if statement when deploying to web
    // User local host for web and desktop development
    // Check Platform.something cause runtime error on web, so check kIsWeb first
    if (kIsWeb || Platform.isWindows) {
      environmentType = EnvironmentType.devLocal;
    }

    await dotenv.load(fileName: environmentType.dotenvFilePath);

    EnvConfigManager.init(
      environmentType: environmentType,
      baseUrl: dotenv.env[NetworkConstants.baseUrl]!,
    );

    final baseUrl = EnvConfigManager.instance.baseUrl;

    final apiProvider = sl<ApiProvider>();
    await apiProvider.init(baseUrl: baseUrl);

    // Preload lottie to cache
    await Future.wait([
      AssetLottie(AppImages.top1).load(),
      AssetLottie(AppImages.top2).load(),
      AssetLottie(AppImages.top3).load(),
    ]);
  }
}
