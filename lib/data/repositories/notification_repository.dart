import 'package:code_space_client/data/data_provider/services/notification_service.dart';

abstract class NotificationRepository {
  Future<bool> updateFcmToken();
}

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationService notificationService;

  NotificationRepositoryImpl({required this.notificationService});

  @override
  Future<bool> updateFcmToken() async {
    try {
      final success = notificationService.updateFcmToken();
      return success;
    } catch (e) {
      throw false;
    }
  }
}
