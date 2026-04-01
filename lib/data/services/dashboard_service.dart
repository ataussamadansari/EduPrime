import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';

class DashboardService {
  final Dio _dio = ApiClient.instance.dio;

  Future<Map<String, dynamic>> getDashboard() async {
    final res = await _dio.get('/dashboard');
    return res.data as Map<String, dynamic>;
  }
}
