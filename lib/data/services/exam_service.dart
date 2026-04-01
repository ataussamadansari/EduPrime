import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';

class ExamService {
  final Dio _dio = ApiClient.instance.dio;

  Future<Map<String, dynamic>> getUpcoming() async {
    final res = await _dio.get('/exams/upcoming');
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getPastResults() async {
    final res = await _dio.get('/exams/past-results');
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getExamDetail(int id) async {
    final res = await _dio.get('/exams/$id');
    return res.data as Map<String, dynamic>;
  }
}
