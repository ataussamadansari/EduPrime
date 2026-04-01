import 'package:dio/dio.dart';
import '../services/notification_service.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final NotificationService _service = NotificationService();

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final data = await _service.getNotifications();
      return (data['data'] as List)
          .map((e) => NotificationModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final data = await _service.getUnreadCount();
      return (data['data']['count'] as num).toInt();
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await _service.markAsRead(id);
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  String _parseError(DioException e) {
    if (e.error is String) return e.error as String;
    final msg = e.response?.data?['message'];
    return msg?.toString() ?? e.message ?? 'Something went wrong';
  }
}
