import 'package:dio/dio.dart';
import '../services/dashboard_service.dart';
import '../models/dashboard_model.dart';

class DashboardRepository {
  final DashboardService _service = DashboardService();

  Future<DashboardModel> getDashboard() async {
    try {
      final data = await _service.getDashboard();
      return DashboardModel.fromJson(data);
    } on DioException catch (e) {
      if (e.error is String) throw e.error as String;
      final msg = e.response?.data?['message'];
      throw msg?.toString() ?? e.message ?? 'Something went wrong';
    }
  }
}
