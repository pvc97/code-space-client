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

  static Future<void> init(
      {required EnvironmentType environmentType,
      required WidgetsBinding binding}) async {
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

    // Preload cache lotties
    await Future.wait([
      AssetLottie(AppImages.top1).load(),
      AssetLottie(AppImages.top2).load(),
      AssetLottie(AppImages.top3).load(),
    ]);

    // Preload cache asset images
    // https://stackoverflow.com/a/62710235
    // Compare with call precacheImage in didChangeDependencies will have the same result

    // Tested with image size 25MB, and it actually works :)
    binding.addPostFrameCallback((_) {
      final BuildContext? context = binding.renderViewElement;
      if (context != null) {
        precacheImage(
            const AssetImage(AppImages.courseDescriptionBackground), context);
        precacheImage(const AssetImage(AppImages.notFound), context);
        precacheImage(const AssetImage(AppImages.student), context);
        precacheImage(const AssetImage(AppImages.teacher), context);
        precacheImage(const AssetImage(AppImages.manager), context);
      }
    });
  }
}
