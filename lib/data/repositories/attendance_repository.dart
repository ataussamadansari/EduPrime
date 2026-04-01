import 'package:dio/dio.dart';
import '../services/attendance_service.dart';
import '../models/attendance_model.dart';

class AttendanceRepository {
  final AttendanceService _service = AttendanceService();

  Future<AttendanceSummary> getSummary() async {
    try {
      final data = await _service.getSummary();
      return AttendanceSummary.fromJson(data);
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<List<AttendanceRecord>> getCalendar(String month) async {
    try {
      final data = await _service.getCalendar(month);
      return (data['data'] as List)
          .map((e) => AttendanceRecord.fromJson(e))
          .toList();
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
