import 'package:code_space_client/constants/app_constants.dart';
import 'package:code_space_client/constants/app_images.dart';

import 'package:code_space_client/configs/env_config_manager.dart';
import 'package:code_space_client/configs/environment_type.dart';
import 'package:code_space_client/constants/network_constants.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/data/data_provider/network/api_provider.dart';
import 'package:code_space_client/utils/logger/logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lottie/lottie.dart';

abstract class AppConfigManager {
  AppConfigManager._();

  static Future<void> init(
      {required EnvironmentType environmentType,
      required WidgetsBinding binding}) async {
    // // TODO: Remove this if statement when deploying to web
    // // User local host for web and desktop development
    // // Check Platform.something cause runtime error on web, so check kIsWeb first
    // if (kIsWeb || Platform.isWindows) {
    //   environmentType = EnvironmentType.devWindowWeb;
    // }

    await Future.wait([
      dotenv.load(fileName: environmentType.dotenvFilePath),
      _initNotification()
    ]);

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

  static Future<void> _initNotification() async {
    if (AppConstants.supportNotification) {
      await Firebase.initializeApp();

      // Config local notification
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.max,
      );

      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      const initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );

      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      // Listen to notification from firebase
      FirebaseMessaging.instance.getInitialMessage().then((message) {
        logger.d('getInitialMessage: ${message?.data}');
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        logger.d('onMessageOpenedApp: ${message.data}');
      });

      FirebaseMessaging.onMessage.listen((message) {
        logger.d('onMessage: ${message.data}');

        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                icon: android.smallIcon,
              ),
            ),
          );
        }
      });

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  logger.d('Handling a background message ${message.data}');
}
