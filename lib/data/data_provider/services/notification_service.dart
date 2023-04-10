import 'package:code_space_client/constants/url_constants.dart';
import 'package:code_space_client/data/data_provider/network/api_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class NotificationService {
  Future<String?> getFcmToken();
  Future<bool> putFcmToken(String token);
}

class NotificationServiceImpl implements NotificationService {
  final ApiProvider apiProvider;

  NotificationServiceImpl({required this.apiProvider});

  @override
  Future<String?> getFcmToken() => FirebaseMessaging.instance.getToken();

  @override
  Future<bool> putFcmToken(String token) async {
    final response = await apiProvider.put(UrlConstants.notifications, params: {
      'fcmToken': token,
    });
    return response?.statusCode == 204;
  }
}
