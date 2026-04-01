import 'package:dio/dio.dart';
import '../services/exam_service.dart';
import '../models/exam_api_model.dart';

class ExamRepository {
  final ExamService _service = ExamService();

  Future<List<ExamApiModel>> getUpcoming() async {
    try {
      final data = await _service.getUpcoming();
      return (data['data'] as List)
          .map((e) => ExamApiModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<List<ExamApiModel>> getPastResults() async {
    try {
      final data = await _service.getPastResults();
      return (data['data'] as List)
          .map((e) => ExamApiModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<ExamApiModel> getExamDetail(int id) async {
    try {
      final data = await _service.getExamDetail(id);
      return ExamApiModel.fromJson(data['data'] as Map<String, dynamic>);
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
