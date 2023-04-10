import 'package:code_space_client/data/data_provider/services/notification_service.dart';

abstract class NotificationRepository {
  Future<String?> getFcmToken();
  Future<bool> putFcmToken(String token);
}

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationService notificationService;

  NotificationRepositoryImpl({required this.notificationService});

  @override
  Future<String?> getFcmToken() => notificationService.getFcmToken();

  @override
  Future<bool> putFcmToken(String token) =>
      notificationService.putFcmToken(token);
}
