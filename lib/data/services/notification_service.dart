import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';

class NotificationService {
  final Dio _dio = ApiClient.instance.dio;

  Future<Map<String, dynamic>> getNotifications() async {
    final res = await _dio.get('/notifications');
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getUnreadCount() async {
    final res = await _dio.get('/notifications/unread-count');
    return res.data as Map<String, dynamic>;
  }

  Future<void> markAsRead(int id) async {
    await _dio.post('/notifications/$id/read');
  }
}
