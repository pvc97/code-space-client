import 'package:code_space_client/constants/url_constants.dart';
import 'package:code_space_client/data/data_provider/network/api_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class NotificationService {
  Future<bool> updateFcmToken();
}

class NotificationServiceImpl implements NotificationService {
  final ApiProvider apiProvider;

  NotificationServiceImpl({required this.apiProvider});

  @override
  Future<bool> updateFcmToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();

    if (fcmToken == null) {
      return false;
    }

    final response = await apiProvider.put(
      UrlConstants.notifications,
      params: {
        'fcmToken': fcmToken,
      },
    );
    return response?.statusCode == 204;
  }
}
