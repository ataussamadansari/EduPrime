import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';

class AttendanceService {
  final Dio _dio = ApiClient.instance.dio;

  /// GET /attendance/summary
  Future<Map<String, dynamic>> getSummary() async {
    final res = await _dio.get('/attendance/summary');
    return res.data as Map<String, dynamic>;
  }

  /// GET /attendance/calendar?month=YYYY-MM
  Future<Map<String, dynamic>> getCalendar(String month) async {
    final res = await _dio.get('/attendance/calendar',
        queryParameters: {'month': month});
    return res.data as Map<String, dynamic>;
  }
}
